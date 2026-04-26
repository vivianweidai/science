# Science

Personal science portfolio and lab notebook — available on [web](https://vivianweidai.com), on the [App Store](https://apps.apple.com/app/id6762091743) for iPhone and iPad (with an embedded Apple Watch companion), and as an Android / Wear OS port under `archives/android/`.

## What's Inside

- **Curriculum** — Interactive reference tables across six subjects (Mathematics, Computing, Physics, Chemistry, Biology, Astronomy) with LaTeX-rendered formulas via KaTeX.
- **Olympiads** — Filterable timeline of academic competitions and study materials.
- **Research** — Hands-on projects using lab instruments (FT-IR spectrometer, four-point probe, melting point system, centrifuge, miniPCR). Each project includes raw data, photos, Jupyter notebooks, and reproducible analysis pipelines.


## Structure

```
src/                 Astro source: layouts, pages, content collections
  pages/zh/          Chinese mirror (/zh/, /zh/research/projects/<folder>/)
content/layout/      Site CSS/JS/icons/hero images
pipeline/worker/     Cloudflare Worker (Static Assets passthrough)
pipeline/scripts/    Python build scripts (truth/*.yml → truth/*.json)
research/projects/   Project folders, English index.md + Chinese index.zh.md siblings
curriculum/          Subject pages built from Word docs → JSON → client-side rendering
olympiads/           Timeline page driven by olympiads.yml → olympiads.json
archives/truth/      Generated JSON (kept here for Apple/Android app backcompat — see CLAUDE.md)
apple/               iOS + watchOS app (SwiftUI, read-only)
android/             Android + Wear OS port (Kotlin/Compose, read-only)
```

## Tech Stack

- **Site** — Astro 5, HTML/CSS/JS, KaTeX
- **Analysis** — Python (pandas, numpy, scipy, matplotlib), Jupyter Notebooks
- **Data** — YAML/JSON source of truth, Word docs for curriculum
- **Hosting** — Cloudflare Workers + Static Assets (custom domain `vivianweidai.com`)
