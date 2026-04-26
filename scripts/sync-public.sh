#!/bin/bash
# Mirror runtime static assets into public/ so Astro's dev server and build
# can serve them. Source locations stay canonical; synced copies under
# public/ are gitignored. Run automatically via `pnpm prebuild`.
# Idempotent — rsync only updates changed files.
set -euo pipefail

cd "$(dirname "$0")/.."

# Site-wide static assets (CSS, JS, images, fonts) — served at /content/layout/
rsync -a content/layout/ public/content/layout/

# Generated JSON consumed by olympiads/research pages and Apple/Android apps.
# IMPORTANT: lives at archives/truth/ (not content/) because the Apple+Android
# apps fetch via raw.githubusercontent.com/.../main/archives/truth/ — moving
# this path would 404 every shipped app install.
rsync -a archives/truth/ public/archives/truth/

# Curriculum PDFs linked from homepage
if [ -d curriculum/archives ]; then
  mkdir -p public/curriculum/archives
  rsync -a curriculum/archives/ public/curriculum/archives/
fi

# Olympiads photos (referenced from photo_url fields in olympiads.json)
if [ -d olympiads/photos ]; then
  mkdir -p public/olympiads/photos
  rsync -a olympiads/photos/ public/olympiads/photos/
fi

# Reference materials (instrument photos, walk-up guides, papers, etc.)
if [ -d research/archives ]; then
  mkdir -p public/research/archives
  rsync -a research/archives/ public/research/archives/
fi

# Per-project assets (photos, data, output, papers)
for dir in research/projects/*/; do
  name=$(basename "$dir")
  mkdir -p "public/research/projects/$name"
  for sub in photos data output papers; do
    if [ -d "$dir$sub" ]; then
      rsync -a "$dir$sub/" "public/research/projects/$name/$sub/"
    fi
  done
done

echo "✓ public/ synced"
