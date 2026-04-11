// Cloudflare Pages Function — sole API handler for the science app.
// Routes:
//   GET    /api/olympiads            → list all olympiads
//   POST   /api/olympiads            → insert one
//   PATCH  /api/olympiads/:id        → update finished/highlighted
//   DELETE /api/olympiads/:id        → remove one
//   GET    /api/textbooks            → list all textbooks
//   POST   /api/textbooks            → insert one
//   PATCH  /api/textbooks/:id        → update finished/highlighted
//   DELETE /api/textbooks/:id        → remove one
//
// Writes require Cloudflare Access — the Function only checks that a
// CF-Access-Authenticated-User-Email header is present. Access itself
// enforces identity at the edge.

const JSON_HEADERS = {
  "content-type": "application/json",
  "cache-control": "no-store",
};

function json(body, init = {}) {
  return new Response(JSON.stringify(body), { ...init, headers: JSON_HEADERS });
}

function bad(msg, status = 400) {
  return json({ error: msg }, { status });
}

function requireAuth(request) {
  const email = request.headers.get("cf-access-authenticated-user-email");
  if (!email) return null;
  return email;
}

async function listTable(db, table) {
  const { results } = await db
    .prepare(`SELECT * FROM ${table} ORDER BY sort_key DESC, id DESC`)
    .all();
  return json({ items: results });
}

async function insertOlympiad(db, body) {
  const { subject, date, sort_key, country, name, finished = 0, highlighted = 0 } = body;
  if (!subject || !date || !sort_key || !country || !name) return bad("missing fields");
  const { meta } = await db
    .prepare(
      `INSERT INTO olympiads (subject,date,sort_key,country,name,finished,highlighted)
       VALUES (?,?,?,?,?,?,?)`
    )
    .bind(subject, date, sort_key, country, name, finished ? 1 : 0, highlighted ? 1 : 0)
    .run();
  return json({ id: meta.last_row_id }, { status: 201 });
}

async function insertTextbook(db, body) {
  const { subject, date, sort_key, title, finished = 0, highlighted = 0 } = body;
  if (!subject || !date || !sort_key || !title) return bad("missing fields");
  const { meta } = await db
    .prepare(
      `INSERT INTO textbooks (subject,date,sort_key,title,finished,highlighted)
       VALUES (?,?,?,?,?,?)`
    )
    .bind(subject, date, sort_key, title, finished ? 1 : 0, highlighted ? 1 : 0)
    .run();
  return json({ id: meta.last_row_id }, { status: 201 });
}

async function patchRow(db, table, id, body) {
  const fields = [];
  const binds = [];
  for (const key of ["finished", "highlighted"]) {
    if (key in body) {
      fields.push(`${key} = ?`);
      binds.push(body[key] ? 1 : 0);
    }
  }
  if (!fields.length) return bad("no patchable fields");
  fields.push(`updated_at = datetime('now')`);
  binds.push(id);
  await db
    .prepare(`UPDATE ${table} SET ${fields.join(", ")} WHERE id = ?`)
    .bind(...binds)
    .run();
  return json({ ok: true });
}

async function deleteRow(db, table, id) {
  await db.prepare(`DELETE FROM ${table} WHERE id = ?`).bind(id).run();
  return json({ ok: true });
}

export const onRequest = async (context) => {
  const { request, env } = context;
  const url = new URL(request.url);
  const parts = url.pathname.replace(/^\/api\/?/, "").split("/").filter(Boolean);
  const [resource, maybeId] = parts;

  if (!env.DB) return bad("DB binding not configured", 500);
  if (resource !== "olympiads" && resource !== "textbooks") return bad("not found", 404);

  if (request.method === "GET") return listTable(env.DB, resource);

  const email = requireAuth(request);
  if (!email) return bad("unauthorized", 401);

  let body = {};
  if (request.method !== "DELETE") {
    try {
      body = await request.json();
    } catch {
      return bad("invalid json");
    }
  }

  if (request.method === "POST") {
    return resource === "olympiads"
      ? insertOlympiad(env.DB, body)
      : insertTextbook(env.DB, body);
  }

  if (!maybeId) return bad("id required", 400);
  const id = Number(maybeId);
  if (!Number.isInteger(id)) return bad("invalid id");

  if (request.method === "PATCH") return patchRow(env.DB, resource, id, body);
  if (request.method === "DELETE") return deleteRow(env.DB, resource, id);

  return bad("method not allowed", 405);
};
