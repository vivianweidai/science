# Science

Personal science portfolio and lab notebook — available on [web](https://vivianweidai.com) and on the [App Store](https://apps.apple.com/app/id6762091743) for iPhone and iPad.

## What's Inside

- **Curriculum** — Interactive reference tables across six subjects (Mathematics, Computing, Physics, Chemistry, Biology, Astronomy) with LaTeX-rendered formulas via KaTeX.
- **Olympiads** — Filterable timeline of academic competitions and study materials.
- **Research** — Hands-on projects using lab instruments (FT-IR spectrometer, four-point probe, melting point system, centrifuge, miniPCR). Each project includes raw data, photos, Jupyter notebooks, and reproducible analysis pipelines.


## Structure

```
research/            Individual project folders (DATA/, PHOTOS/, OUTPUT/)
curriculum/          Subject pages built from Word docs → JSON → client-side rendering
olympiads/           Timeline page driven by olympiads.yml → olympiads.json
archives/
  CONTENT/           Source data (olympiads.yml, curriculum.json, images)
  LAYOUT/            CSS, JS, and Python build scripts
  APPLE/             iOS app (SwiftUI, read-only)
  CHINESE/           Chinese language mirror
```

## Tech Stack

- **Site** — Jekyll, HTML/CSS/JS, KaTeX
- **Analysis** — Python (pandas, numpy, scipy, matplotlib), Jupyter Notebooks
- **Data** — YAML/JSON source of truth, Word docs for curriculum
- **Hosting** — GitHub Pages with custom domain
