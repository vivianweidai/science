# Migration: Cloudflare D1/Pages → GitHub Pages + YAML source of truth

This repo was migrated from **Cloudflare D1 + Cloudflare Pages Functions** to
**YAML files in Git + GitHub Pages**. This doc records what changed, what you
still need to do by hand (DNS + GitHub repo settings), and how the new edit
workflow works.

## What changed in the repo

**Source of truth is now YAML:**
- `archives/CONTENT/olympiads.yml` — 49 olympiad events
- `archives/CONTENT/textbooks.yml` — 83 textbooks/courses

**Build pipeline:**
- `archives/LAYOUT/build_listings.py` parses the YAML, validates schema, computes
  `sort_key`, and emits `archives/CONTENT/olympiads.json` and `archives/CONTENT/textbooks.json`
  in the exact shape the iOS app used to get from the old API.

**Webapp (`olympiads/index.md`):**
- Was: ~250 lines of hand-maintained `<table>` markup
- Now: thin HTML shell + client-side JS that `fetch()`es the two JSON files
  from `../archives/` and renders the same tables dynamically.

**iOS (`apple/shared/API/APIClient.swift`):**
- Was: hit `https://vivianweidai.com/api/olympiads` (Cloudflare Function → D1)
- Now: hit `https://raw.githubusercontent.com/vivianweidai/science/main/archives/CONTENT/olympiads.json`
- Write methods (`setOlympiadFinished`, `setTextbookFinished`) were dead code
  and were deleted.

**Deleted outright:**
- `functions/api/[[path]].js` — Cloudflare Pages Function (read + admin write)
- `schema.sql` — D1 schema
- `migrations/` — D1 seed SQL
- `wrangler.toml` — Cloudflare config
- `archives/olympiads.csv`, `archives/textbooks.csv` — replaced by YAML
- `scripts/build_migration.py` — CSV→SQL converter, no longer needed

**Added:**
- `.github/workflows/pages.yml` — validates listings JSON is fresh, builds
  Jekyll, deploys to GitHub Pages.
- `CNAME` — tells GitHub Pages to serve this repo at `vivianweidai.com`.

## What you still need to do by hand

These are things I cannot do from the CLI; they all happen in web UIs:

### 1. Enable GitHub Pages on the repo
- Go to **Settings → Pages** on https://github.com/vivianweidai/science
- **Source:** "GitHub Actions" (not "Deploy from a branch")
- **Custom domain:** `vivianweidai.com` (should auto-populate from the CNAME file)
- Check **Enforce HTTPS** once GitHub has provisioned the cert (takes a few minutes
  after DNS is pointed at GitHub).

### 2. Point DNS at GitHub Pages
You currently have `vivianweidai.com` pointing at Cloudflare Pages. Change it to
GitHub Pages. In your DNS host (Cloudflare, Namecheap, wherever the domain is
registered):

**Apex record (`vivianweidai.com`):** create four A records pointing at GitHub's
Pages IPs:
```
185.199.108.153
185.199.109.153
185.199.110.153
185.199.111.153
```

**`www` subdomain (optional):** CNAME to `vivianweidai.github.io`.

If the domain is on Cloudflare DNS, make sure the records are **DNS only** (gray
cloud), not proxied (orange cloud) — proxied records break GitHub's cert
provisioning. You can re-enable the proxy later if you want.

TTL can be 5 minutes or whatever your provider's minimum is.

### 3. Tear down Cloudflare Pages and D1
Once GitHub Pages is live at vivianweidai.com and you've confirmed the site
loads correctly:

- **Cloudflare Pages project:** delete the `science` project in the Cloudflare
  dashboard (it's no longer needed and will keep auto-building from the repo
  and failing because there's no `wrangler.toml`).
- **Cloudflare Access:** delete the policy that used to gate `/api/admin/*`.
  It's no-op now but it's cruft.
- **D1 database:** delete the `science` D1 database (`682188ef-...`) in the
  Cloudflare dashboard. You can also run `npx wrangler d1 delete science`
  locally if you have wrangler still installed.

None of these are urgent; they're just cleanup.

### 4. iOS app update
The iOS app now points at a different URL, so you need to build and ship a new
release via Xcode and App Store Connect. Existing installs will keep working
against the old URL until the domain cuts over (at which point the old URL
will 404 and the app will show a load error), then stop working entirely until
users update. Timeline options:

- **Safest:** submit the new iOS build to the App Store **first**, wait for
  approval, then do the DNS cutover. Brief (hours-to-a-day) window where old
  app still points at the (now-404'ing) old URL.
- **Fastest:** cut over DNS immediately and submit iOS update in parallel. App
  will be broken for users until they update.

Consider bundling a fallback `olympiads.json` / `textbooks.json` in the app
(copy them into the Xcode project as resources) and adding a catch on the fetch
so the app falls back to bundled data if the network request fails. This is
both an App Store-review win ("app works offline") and a soft-failure net for
any future URL disruption.

## Editing workflow (how you update listings from now on)

1. Edit `archives/CONTENT/olympiads.yml` or `archives/CONTENT/textbooks.yml` in your editor.
   The schema is enforced by `archives/LAYOUT/build_listings.py` — see that file for
   the full list of required and optional fields.
2. Run:
   ```
   python archives/LAYOUT/build_listings.py
   ```
   This regenerates `archives/CONTENT/olympiads.json` and `archives/CONTENT/textbooks.json`.
   If your edit has a schema violation (typo in subject, missing field, bad
   date format), the script will tell you exactly which entry.
3. `git add archives/ && git commit && git push`.
4. GitHub Actions builds Jekyll and deploys to GitHub Pages within about a
   minute of the push landing.

If you push without rebuilding the JSON, the GitHub Actions workflow will fail
the `validate-listings` job with a diff showing what's stale, and refuse to
deploy. No way to accidentally ship an inconsistent site.

## YAML schema

**Olympiads (`archives/CONTENT/olympiads.yml`):**
```yaml
- subject: Mathematics      # one of: Mathematics, Computing, Physics, Chemistry, Biology, Astronomy
  date: November 2025       # "Month YYYY" — any full English month name
  country: United States    # free text
  name: American Mathematics Competition 12   # free text
  finished: false           # true = strikethrough on the page
  highlighted: true         # true = highlighted row background
```

**Textbooks (`archives/CONTENT/textbooks.yml`):**
```yaml
- subject: Physics          # same subject list
  date: December 2025       # "Month YYYY" OR "Future" for unscheduled
  title: Physics Olympiad Handouts by Kevin Zhou
  finished: false
  highlighted: true
  # Optional — if set, the webapp wraps the title (or a substring of it) in an <a>.
  url: https://knzhou.github.io
  link_text: Physics Olympiad Handouts   # if omitted, the whole title becomes the link
```

`url` and `link_text` are webapp-only — the iOS decoder ignores them.

## Rollback

If something goes catastrophically wrong with GitHub Pages, the rollback to
Cloudflare Pages is: restore `wrangler.toml`, `functions/`, `schema.sql`,
`migrations/` from git history, re-point DNS at Cloudflare Pages, and redeploy.
The D1 database may still exist depending on whether step 3 above ran.
