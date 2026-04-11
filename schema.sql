-- Cloudflare D1 schema for the science app.
-- Two tables mirror the CSVs under archives/; the CSVs stay as the initial
-- seed and are imported via migrations/0001_initial.sql.

CREATE TABLE IF NOT EXISTS olympiads (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  subject     TEXT NOT NULL,
  date        TEXT NOT NULL,    -- "Month YYYY" as displayed
  sort_key    TEXT NOT NULL,    -- "YYYY-MM" for ordering
  country     TEXT NOT NULL,
  name        TEXT NOT NULL,
  finished    INTEGER NOT NULL DEFAULT 0,
  highlighted INTEGER NOT NULL DEFAULT 0,
  updated_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_olympiads_subject ON olympiads(subject);
CREATE INDEX IF NOT EXISTS idx_olympiads_sort    ON olympiads(sort_key DESC);

CREATE TABLE IF NOT EXISTS textbooks (
  id          INTEGER PRIMARY KEY AUTOINCREMENT,
  subject     TEXT NOT NULL,
  date        TEXT NOT NULL,    -- "Month YYYY" or "Future"
  sort_key    TEXT NOT NULL,    -- "YYYY-MM" or "9999-12" for Future
  title       TEXT NOT NULL,
  finished    INTEGER NOT NULL DEFAULT 0,
  highlighted INTEGER NOT NULL DEFAULT 0,
  updated_at  TEXT NOT NULL DEFAULT (datetime('now'))
);

CREATE INDEX IF NOT EXISTS idx_textbooks_subject ON textbooks(subject);
CREATE INDEX IF NOT EXISTS idx_textbooks_sort    ON textbooks(sort_key DESC);
