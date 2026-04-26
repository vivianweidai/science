# Science

Personal science portfolio and lab notebook — available on [web](https://vivianweidai.com), on the [App Store](https://apps.apple.com/app/id6762091743) for iPhone and iPad (with an embedded Apple Watch companion), and as an Android / Wear OS port under `archives/android/`.

## What's Inside

- **Curriculum** — Interactive reference tables across six subjects (Mathematics, Computing, Physics, Chemistry, Biology, Astronomy) with LaTeX-rendered formulas via KaTeX.
- **Olympiads** — Filterable timeline of academic competitions and study materials.
- **Research** — Hands-on projects using lab instruments (FT-IR spectrometer, four-point probe, melting point system, centrifuge, miniPCR). Each project includes raw data, photos, Jupyter notebooks, and reproducible analysis pipelines.


## Structure

```
src/                       Astro source: layouts, pages, content collections (English + zh)
pipeline/worker/           Cloudflare Worker (Static Assets passthrough)
pipeline/scripts/          Python build scripts (.docx → markdown, YAML → JSON)
content/
  layout/                  Site CSS/JS/icons/hero images
  truth/                   YAML source + generated JSON (consumed by web + apps)
  curriculum/notes/        Curriculum NOTES PDFs (linked from homepage)
  curriculum/source/       Per-discipline source markdown (build_curriculum.py output)
  olympiads/photos/        Photos referenced from olympiads.json
  research/archives/       Reference materials (instrument photos, guides, papers)
  research/projects/       Project folders, English index.md + Chinese index.zh.md siblings
apple/                     iOS + watchOS app (SwiftUI, read-only)
android/                   Android + Wear OS port (Kotlin/Compose, read-only)
```

## Tech Stack

- **Site** — Astro 5, HTML/CSS/JS, KaTeX
- **Analysis** — Python (pandas, numpy, scipy, matplotlib), Jupyter Notebooks
- **Data** — YAML/JSON source of truth, Word docs for curriculum
- **Hosting** — Cloudflare Workers + Static Assets (custom domain `vivianweidai.com`)
