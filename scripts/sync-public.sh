#!/bin/bash
# Mirror the canonical content/ tree into public/content/ so Astro's dev
# server and build can serve it. URLs match disk paths 1:1: a file at
# content/X/Y is served at /content/X/Y. Run via `pnpm prebuild`.
# Idempotent — rsync only updates changed files.
set -euo pipefail

cd "$(dirname "$0")/.."

mkdir -p public/content
rsync -a content/ public/content/

echo "✓ public/content/ synced from content/"
