# SCIENCE — Claude Code Instructions

## YOUR ROLE

Process experimental data and build reproducible analysis pipelines. Parse raw instrument outputs, clean and validate data, perform statistical analysis, and generate visualizations.

## REFERENCE MATERIALS

All background materials live in the repo under `public/research/archives/`. Read these as needed for instrument details, context, and research planning:

- **`public/research/archives/technology/`** — canonical instrument list (`toys.pdf`), plus technology landscape, UNR/UBC lab and faculty catalogues, and the university comparison.
- **`public/research/archives/guides/`** — instrument walk-up guides (one PDF per instrument, e.g. `Thermo Scientific Nicolet 380 FT-IR Spectrometer.pdf`).
- **`public/research/archives/papers/`** — classic papers (Turing, Rosenblatt, Hubel & Wiesel, Q-Learning, Transformers, AlphaGo, etc.).
- **`public/research/archives/photos/`** — reference photos.

`IDEAS.md` at the repo root is a living backlog of research project ideas — promote one to `public/research/projects/YYYYMMDD Name/` when a pilot starts.

All instrument names in code and prose must exactly match what's in `public/research/archives/technology/toys.pdf`.

## STACK

- **Astro 5** — static site generator. Builds to `pipeline/worker/dist/` (co-located with the Worker that serves it).
- **Cloudflare Workers + Static Assets** — serves the build output at `vivianweidai.com`. The Worker is a true passthrough to the `ASSETS` binding (no edge logic).
- **GitHub** — source control only. Push triggers nothing.
- **Apple/Android** — native apps in `apple/` and `android/` consume `vivianweidai.com/{olympiads,research,curriculum}/*.json` (and per-discipline markdown under `vivianweidai.com/curriculum/source/`).

## REPO STRUCTURE

Top-level: `apple/ android/ pipeline/ public/ src/` plus the Astro config files. Five directories — minimal because of one deliberate convention deviation (see below).

```
science/
├── astro.config.mjs        # Astro config (trailingSlash: 'always', site: vivianweidai.com)
├── package.json            # Astro deps + dev/build scripts (no pre/post-build hooks needed)
├── tsconfig.json           # Astro strict TS preset
├── pnpm-lock.yaml
├── CLAUDE.md · README.md · IDEAS.md · .gitignore
│
├── src/                    # Astro source
│   ├── content.config.ts   # Content collections: projects (English) + zhProjects (Chinese)
│   ├── layouts/            # Astro components AND their associated CSS/JS:
│   │                       #   Default.astro + Project.astro
│   │                       #   base.css / tabs.css / curriculum.css   (imported by .astro)
│   │                       #   curriculum.js / curriculum.zh.js       (imported via ?url)
│   └── pages/              # File-based routing
│       ├── index.astro     # /
│       ├── curriculum/     # /curriculum/
│       ├── olympiads/      # /olympiads/
│       ├── research/       # /research/ + dynamic /research/projects/[slug]/
│       ├── privacy.md      # /privacy/
│       └── zh/             # Chinese mirror at /zh/...
│           └── research/projects/[slug]/   # /zh/research/projects/<folder>/
│
├── pipeline/
│   ├── worker/             # Cloudflare Worker (ASSETS passthrough)
│   │   ├── wrangler.toml   # name=science, [assets] dir=./dist (Astro outputs here)
│   │   ├── package.json
│   │   └── src/index.js    # `env.ASSETS.fetch(request)`
│   └── scripts/            # Python build scripts
│       ├── build_olympiads.py / build_toys.py  # YAML → JSON
│       └── build_curriculum.py                 # .docx → markdown + curriculum.json
│
├── public/                 # Astro public/ — served at site root; our source-of-truth lives directly here
│   ├── curriculum/
│   │   ├── notes/                # Per-discipline DOCX + PDF (linked from homepage)
│   │   ├── source/               # Per-discipline markdown (build_curriculum.py output;
│   │   │                         #   ALSO fetched by Apple+Android apps for in-app rendering)
│   │   └── curriculum.json       # Generated manifest — DO NOT EDIT BY HAND
│   ├── olympiads/
│   │   ├── photos/               # Photos referenced from olympiads.json photo_url fields
│   │   ├── olympiads.yml         # Source of truth — edit, then rebuild
│   │   └── olympiads.json        # Generated — DO NOT EDIT BY HAND
│   └── research/
│       ├── archives/             # Background reference materials (instrument photos,
│       │                         #   walk-up guides, classic papers, lab catalogues)
│       ├── projects/<folder>/    # YYYYMMDD Project Name
│       │   ├── index.md          # English project page (Content Collection 'projects')
│       │   ├── index.zh.md       # Chinese sibling (Content Collection 'zhProjects')
│       │   ├── data/             # Raw instrument data
│       │   ├── photos/           # setup/, samples/, data/ (data excluded from shuffle)
│       │   ├── papers/           # Background papers
│       │   └── output/           # Analysis scripts, notebooks, plots
│       ├── layouts/              # JS/SVG/PNG referenced from project markdown
│       │                         #   (shuffle.js, tabs.js, cat.svg, spikey.png — must
│       │                         #    stay in public/ since Vite doesn't transform .md URLs)
│       ├── toys.yml              # Source of truth — edit, then rebuild
│       └── toys.json             # Generated — DO NOT EDIT BY HAND
│
├── apple/                  # iOS + watchOS app source (SwiftPM + XcodeGen)
└── android/                # Android + Wear OS source (Gradle multi-module)
```

**Convention deviation: no top-level `content/`; everything goes directly under `public/`.** The cross-repo convention puts source-of-truth in a top-level `content/` dir. We deviate because Astro already has a special `public/` dir (served verbatim at the site root). With our setup, `public/` IS the content dir — files at `public/X/Y` serve at `/X/Y`. No `content/` layer, no `/content/` URL prefix, no sync step. The Astro Content Collection loader points at `public/research/projects/`; the dynamic route's photo discovery walks the same path. Apple/Android fetch from `vivianweidai.com/{olympiads,research,curriculum}/...`.

**URL ↔ disk mapping.** Pages have clean URLs (`/`, `/curriculum/`, `/research/projects/<folder>/`, etc.). Files under `public/<path>` serve at `/<path>` — 1:1 mapping, no rewrites. Page URLs and asset URLs coexist under the same prefix (e.g., `/research/projects/<folder>/` is the rendered HTML page; `/research/projects/<folder>/index.md` is the raw markdown the apps fetch; `/research/projects/<folder>/photos/...` are the photos).

**Activities workflow.** `public/olympiads/olympiads.yml` is the single source of truth for olympiads and textbooks. After editing, run `python pipeline/scripts/build_olympiads.py` to regenerate `public/olympiads/olympiads.json`, then `pnpm build && cd pipeline/worker && pnpm run deploy` to ship. The website (`/olympiads/` via client-side JS) and the Apple/Android apps both fetch the same JSON via `https://vivianweidai.com/olympiads/olympiads.json`. Same pattern for `toys.yml` (research) and the curriculum `.docx` sources. No database, no API, no admin endpoint.

Each research project lives in a date-prefixed folder under `research/projects/`:

```
YYYYMMDD Project Name/
├── data/                   # Raw data from instruments (CSVs, spectra, etc.)
├── photos/                 # Experiment photos, organized by purpose
│   ├── setup/              # Setup + sample shots — feed the top-page shuffle
│   ├── samples/            # (optional) sample close-ups — also shuffled
│   └── data/               # Photographs of handwritten data sheets — excluded from shuffle, shown via `data_photos` frontmatter
├── papers/                 # Background papers
├── output/                 # Analysis output: scripts, notebooks, figures, processed data
│   ├── *.py / *.ipynb      # Analysis code
│   ├── *.png               # Generated plots and visualizations
│   └── *.csv / *.json      # Processed/cleaned data
├── index.md                # Project overview, methods, results summary
```

- **Never modify raw data files.** Read from `data/`; write all generated outputs to `output/`.
- Create subdirectories (`data/`, `photos/`, `papers/`, `output/`) as needed when setting up or processing a project — existing projects use these names; follow the existing pattern rather than inventing new ones.
- **Photo subfolders.** All experiment images live under `photos/`, split by purpose: `photos/setup/` (and optionally `photos/samples/`) for shots that should rotate through the top-of-page shuffle, and `photos/data/` for handwritten data sheets that are surfaced explicitly via the `data_photos` frontmatter and the in-page `#data-grid`. The `project.html` layout filters `photos/data/` out of the shuffle pool so data sheets never appear in the hero — keep this contract intact when adding new subfolders.
- **Photo naming.** Within each subfolder, name files sequentially by chronological order: `setup1.jpeg`, `setup2.jpeg`, … and `data1.jpeg`, `data2.jpeg`, …. The numeric suffix encodes capture order (oldest = 1). Don't keep the original camera names like `20240920 Catfood G.jpeg` once a project is being committed — rename with `git mv` so the index.md frontmatter and any in-prose references stay short and stable.

## DEV WORKFLOW

- **Build & deploy** — `pnpm build` from repo root (writes Astro output to `pipeline/worker/dist/`), then `cd pipeline/worker && pnpm run deploy` (wrangler ships dist via Static Assets binding). GitHub push is backup only.
- **Local preview** — `pnpm dev` from the repo root (port 4321). Astro serves on save with hot reload. Use Safari for visual checks.
- **One-off HTML mockups (non-Astro)** — keep in `~/GITHUB/scratch/<topic>.html` per the global convention; serve with `live-server` if needed. Don't recreate the in-repo `scratch/` Jekyll preview folder — Astro's dev server replaces it.
- **Layout-aware Astro mockups** — drop a temp `.astro` file under `src/pages/scratch-<topic>.astro`, view via `pnpm dev`, then `git restore` to remove. Same exception pattern as other Astro repos.
- **Showing the user — default is Safari.** After a change, open the relevant URL in Safari (`open -a Safari 'http://127.0.0.1:4321/<path>'`) so the user sees the real rendering natively. `qlmanage -t -s 1200 -o /tmp <file>.html` is only an inline-in-chat fallback.
- **Promoting from scratch to site** — move the chosen asset into the appropriate tracked path (e.g. `archives/layout/`, `archives/truth/`, or a project's `output/`).

## ANALYSIS GUIDELINES

- **Tool choice is flexible** — use Python, R, Julia, shell scripts, or whatever fits the task best. Default to Python scientific stack (pandas, numpy, scipy, matplotlib, seaborn) when there's no strong reason to pick something else.
- **Visualizations** — default to matplotlib/seaborn. Use clear axis labels, units, titles, and legends. Save figures as PNG (300 dpi).
- **Reproducibility** — every analysis script should be runnable end-to-end from the project folder. Include comments explaining what each step does and why. Pin library versions in a `requirements.txt` if the pipeline uses non-standard packages.
- **Data validation** — always inspect and summarize raw data before analysis (shape, missing values, outliers, units). Flag anything unexpected.
- **Jupyter notebook conventions:**
  - **Colab compatibility** — all data file references must use absolute GitHub raw URLs (e.g., `https://raw.githubusercontent.com/vivianweidai/science/main/...`) so notebooks work in Colab. Ship notebooks **with outputs** so GitHub renders results statically; Colab users re-run themselves.
  - **Sections** — use numbered markdown heading cells (`## 1. Title`, `## 2. Title`, etc.) to separate logical sections. Typical flow: Data Collection → Load and Inspect Data → Visualize → Statistical Test → Conclusion.
  - **Output styling** — use plain `print()` for text output. Keep code tight and minimal — no HTML boxes, no `IPython.display`, no extra spacing hacks.
  - **Chart styling** — use matplotlib defaults (no custom fonts, no facecolor overrides). Use soft, muted pastels for colours — reference palette: Mathematics blue `#c5d9f7`, Computing purple `#d9ccee`, Physics coral `#f9c4a8`, Chemistry lime `#d4e8a0`, Biology teal `#a8ddd4`, Astronomy rose `#f4c2cb`. For data line traces use slightly deeper tones like `#d95f5f`. Always keep colours light and airy — never saturated or bold. Save as PNG (300 dpi). If a project produces many images, save into an `output/images/` subfolder; if only one or two images, save directly into `output/`.
  - **Colab badge** — add a final markdown cell with `---` separator, then just the Colab badge image link (no descriptive text): `<a href="COLAB_URL"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab" style="vertical-align:middle;"></a>`

## WRITING STYLE FOR PROJECT PAGES

Research project pages are **personal toolkit notes**, not publications. Their purpose is a fast future-you glance: what the toy does, what makes it different from its neighbors, and enough of a hook to go deeper if needed. They are the scaffold for real research, not the research itself.

- **Note-and-bullet first.** Prefer short bullets over paragraphs. When a paragraph is needed, keep it to 1–2 sentences.
- **Differentiate, don't summarize.** For every toy or technique, lead with what distinguishes it from the others on the page or in the repo. If two instruments could both measure the same thing, say which one this page uses and why.
- **Cut publication scaffolding.** No abstract-style intros, no "in this work we…", no restating what the reader can read below. Skip motivation paragraphs that aren't load-bearing.
- **Use font styling judiciously.** One or two bolds per section at most — ideally only the proper noun of the instrument or the differentiator itself. Avoid stacking bold + italic + sub/superscripts unless the notation carries real information (λ<sub>max</sub> is fine; *italicizing every verb* is not).
- **Push specifications to Setup tables.** Ranges, software names, filename patterns, cuvette sizes — all of that lives in the Setup or Data table, not in overview prose.
- **Tabs and section-heads are the structure.** Let the page layout carry the differentiation (tabs per instrument, one section per pass) instead of explaining the structure in prose.

Existing pages that model this style: `20260419 IR Spectroscopy/index.md` and `20260420 UV-Vis Spectroscopy/index.md`. When adding a new project or revising an old one, aim for their level of density.

## INSTRUMENTS & DATA FORMATS

**All instrument names must exactly match the canonical Toy List.** When referencing any instrument, verify the name — do not abbreviate, add prefixes, or rearrange words. Instruments used so far:
- **Thermo Scientific Nicolet 380 FT-IR Spectrometer** — CSV files with wavenumber (cm⁻¹) vs. transmittance/absorbance
- **Jandel RM3 Four-Point Probe** — sheet resistance measurements (Ω/□)
- **OptiMelt Automated Melting Point System** — non-functional (touchscreen unresponsive)
- **Next up: TA Instruments TGA Q50** — thermogravimetric analysis (walk-up guide available)

## GIT WORKFLOW

- **Always work on the `main` branch.** Never create feature branches, worktrees, or PRs. Commit and push directly to `main`.
- Before starting work, verify you are on `main` with `git branch`. If not, switch with `git checkout main`.

## GITHUB & VISIBILITY

This repo is synced to GitHub at `vivianweidai/science` and served at `vivianweidai.com`. Everything is publicly viewable. Keep this in mind:
- Do not commit sensitive or personal information.
- **Never include researcher names or lab location in any public-facing files.** Project pages should include Date and Instrument but not Researchers or Location.
- **Always resize images before committing.** No image may be committed over ~500 KB or wider than 1600 px — resize it first (`sips -Z 1600 -s formatOptions 82 file.jpeg --out file.jpeg`). The 1600 px cap is intentional for this repo: photos here are decorative illustrations inside research reports, not hero content that readers zoom into. (Compare: `domains/` uses 2560 px because it serves full-screen wallpapers where retina sharpness matters. Different caps, different jobs.) For photos saved as PNG without transparency, convert to JPEG (`sips -s format jpeg`) and update every markdown reference. For PNGs with transparency that must stay PNG, run `pngquant --quality=65-85 --ext .png --force file.png`. This rule applies to **all** directories including `data/` and `photos/` — "never modify raw data files" refers to analysis outputs, not repo hygiene. **Before every commit**, run `find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -size +500k -not -path './.git/*' -not -path '*/dist/*' -not -path './node_modules/*'` and shrink anything that surfaces.
- **Always compress every PDF before committing — even small ones.** Small PDFs still shrink (often 30–50 %) at zero quality cost; this batches up to meaningful repo-history savings. Use Ghostscript (`gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=out.pdf in.pdf`) on **every** new or modified PDF in the staging set; use `/screen` (72 DPI) for huge image-heavy manuals, `/ebook` (150 DPI) when text fidelity matters. Always **verify a mid-document page renders** after compression (`pdftoppm -r 60 -f 50 -l 50 out.pdf /tmp/check`) — some sources have parser-broken streams that silently produce blank pages. Keep the compressed version only if (a) it shrunk, (b) page count matches the original, and (c) `gs` reported zero "Page drawing error" warnings. The pre-commit hook in `.githooks/pre-commit` only warns at 5 MB — it's a safety net, not the rule. On a fresh Mac, install the tools first: `brew install ghostscript poppler` (poppler provides `pdftoppm` and `pdfinfo`).
- **Pre-commit warning hook is in `.githooks/pre-commit`.** It scans staged files and prints a warning (does NOT block) when an image is over 500 KB or a PDF is over 5 MB. To activate after a fresh clone, run once: `git config core.hooksPath .githooks`. Treat warnings case-by-case — sometimes a large file is genuinely intentional (e.g. a scanned classic paper), sometimes it needs compression first.
- **Photos:** If a project has 4+ photos, use the 2x2 photo grid with shuffle button. **The shuffle pool is auto-populated by the `project.html` layout** — it scans every `.jpg`/`.jpeg`/`.png` file under the project's `photos/` subtree (both `photos/setup/` and `photos/samples/`) and injects them as `window._pagePhotos`. Do not list photos in front matter; do not add a per-page `<script>var _pagePhotos = ...</script>` line. Just include the `<div class="photo-grid">` + `<button class="shuffle-btn">` markup and the `<script src="/archives/layout/shuffle.js"></script>` tag. The page gets every new photo automatically when you drop it into the right folder. If a project has only 1 photo, use a single hero image with `<div class="hero-single">` for rounded styling and controlled height.
- **Date/Instrument metadata** should be right-aligned below the photos using `<div class="project-meta">`. Put Instrument on a new line with `<br>`.
- **Results links** should point to the GitHub blob URL (e.g. `https://github.com/vivianweidai/science/blob/main/...`) so files render inside GitHub.
- Ensure all code, data, and documentation is presentable and well-organized.
- Each project's `index.md` (not README.md) serves as the public-facing overview. Astro's content collection loader globs `*/index.md` (and `*/index.zh.md` for Chinese) under `research/projects/`, so the filename matters.
- **When creating a new project**, always add it to the tabbed project table in `research/index.md` under the appropriate discipline tab (Mathematics, Computing, Physics, Chemistry, Biology, Astronomy). Also add any new instruments to the Instruments section in `research/index.md`.
- **Do not auto-commit or push.** The user reviews and commits locally. After finishing a change, show the change in Safari (see LOCAL PREVIEWS) and stop there — no `git commit` or `git push` unless explicitly asked. Before the user commits, scan for oversized images (see the resize rule above) and shrink any offenders — once a large blob is in git history it stays there forever.

## PROJECT README TEMPLATE

When creating a new project README, use this template:

### Template A: Multiple photos (4+)

```markdown
---
layout: project
project: [Short Project Name]
---

# [Experiment Title]

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="Experiment photo">
  <img id="photo-1" alt="Experiment photo">
  <img id="photo-2" alt="Experiment photo">
  <img id="photo-3" alt="Experiment photo">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">Shuffle Photos</button>

<script src="/archives/layout/shuffle.js"></script>

<div class="project-meta">[Month Dayth Year]<br>[Instrument name]</div>
```

The shuffle pool is populated automatically by `project.html` — it scans every image file under `photos/` (both `setup/` and `samples/` subfolders). No `photos:` array, no `_pagePhotos` inline script. Drop a new photo into `photos/` and it joins the shuffle on next page load.

### Template B: Single photo

```markdown
---
layout: project
project: [Short Project Name]
---

# [Experiment Title]

<div class="hero-single"><img src="photos/[filename]" alt="[description]"></div>

<div class="project-meta">[Month Dayth Year]<br>[Instrument name]</div>
```

### Common sections (both templates)

```markdown
## Overview

[1-2 paragraph description]

## Setup

| Category | Details |
|----------|---------|
| [Category] | [details] |

[Prose description of the experimental procedure, flowing naturally from the materials table above.]

## Samples

| Category | Samples |
|----------|---------|
| [Category] | [samples] |

[Description of samples.]

## Data

[Description of data format and what was recorded.]

[If `photos/data/` contains data-sheet images, add a photo grid here using the `data_photos` frontmatter (paths like `photos/data/data1.jpeg`). Show all photos without a shuffle button if count <= 4. Only add shuffle button if there are more photos than grid slots. Use `three-col` class for 3 images. This grid is independent from the top PHOTOS shuffler — `photos/data/` is filtered out of the shuffle pool.]

## Results

[Summary. Link to written report first, then notebook:]

See the <a href="https://github.com/vivianweidai/science/blob/main/[path]">written report</a>, the <a href="https://github.com/vivianweidai/science/blob/main/[path]">static notebook</a> or <a href="https://colab.research.google.com/github/vivianweidai/science/blob/main/[path]">run the reproducible analysis yourself</a>.

---

<div class="footer"><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/science/tree/main/[URL-encoded folder name]">View on GitHub</a></div>
```

Always use `index.md` (not `README.md`) for project pages. Always include the footer div. The top-page shuffle is auto-populated from `photos/setup/` (and `photos/samples/` if present); use the `data_photos` frontmatter to point the in-page data grid at `photos/data/` images. **Samples** is a top-level `##` section (not a subsection of Setup).

**Never add a "#" / row-number column to any table** — in Setup, Samples, Results, or anywhere else. Markdown tables already read as a list; a numbering column only adds visual noise. If ordering matters, convey it through row sequence alone. This rule is repo-wide, not sample-table-specific.
