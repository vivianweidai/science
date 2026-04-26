# Science

Personal science portfolio and lab notebook — available on [web](https://vivianweidai.com), on the [App Store](https://apps.apple.com/app/id6762091743) for iPhone and iPad (with an embedded Apple Watch companion), and as an Android / Wear OS port under `archives/android/`.

## What's Inside

- **Curriculum** — Interactive reference tables across six subjects (Mathematics, Computing, Physics, Chemistry, Biology, Astronomy) with LaTeX-rendered formulas via KaTeX.
- **Olympiads** — Filterable timeline of academic competitions and study materials.
- **Research** — Hands-on projects using lab instruments (FT-IR spectrometer, four-point probe, melting point system, centrifuge, miniPCR). Each project includes raw data, photos, Jupyter notebooks, and reproducible analysis pipelines.


## Structure

```
src/
  layouts/                 Astro layout components
  styles/ + scripts/       Site-wide CSS + JS (bundled by Astro)
  pages/                   File-based routing (English + /zh/ mirror)
pipeline/worker/           Cloudflare Worker (Static Assets passthrough)
pipeline/scripts/          Python build scripts (.docx → markdown, YAML → JSON)
public/                    Astro public/ (served at site root)
  content/                 Source-of-truth — organized by page, not by type
    curriculum/            notes/ + source/ + curriculum.json + curriculum.png
    olympiads/             photos/ + olympiads.{yml,json}
    research/              archives/ + projects/ + toys.{yml,json} + shuffle.js / cat.svg / etc.
apple/                     iOS + watchOS app (SwiftUI, read-only)
android/                   Android + Wear OS port (Kotlin/Compose, read-only)
```

## Tech Stack

- **Site** — Astro 5, HTML/CSS/JS, KaTeX
- **Analysis** — Python (pandas, numpy, scipy, matplotlib), Jupyter Notebooks
- **Data** — YAML/JSON source of truth, Word docs for curriculum
- **Hosting** — Cloudflare Workers + Static Assets (custom domain `vivianweidai.com`)
