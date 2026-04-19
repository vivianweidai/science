# SCIENCE — Claude Code Instructions

## YOUR ROLE

Process experimental data and build reproducible analysis pipelines. Parse raw instrument outputs, clean and validate data, perform statistical analysis, and generate visualizations.

## REFERENCE MATERIALS

All background materials now live in the repo under `research/archives/`. Read these as needed for instrument details, context, and research planning:

- **`research/archives/toys/`** — canonical instrument list (`toys.pdf`), plus technology landscape, UNR/UBC lab and faculty catalogues, and the university comparison.
- **`research/archives/guides/`** — instrument walk-up guides (one PDF per instrument, e.g. `Thermo Scientific Nicolet 380 FT-IR Spectrometer.pdf`).
- **`research/archives/papers/`** — classic papers (Turing, Rosenblatt, Hubel & Wiesel, Q-Learning, Transformers, AlphaGo, etc.).
- **`research/archives/photos/`** — reference photos.

All instrument names in code and prose must exactly match what's in `research/archives/toys/toys.pdf`.

## REPO STRUCTURE

```
science/
├── _layouts/               # Jekyll layouts (default.html, project.html)
├── _config.yml             # Jekyll config (title, baseurl)
├── index.md                # Landing page (vivianweidai.com)
├── CNAME                   # Custom domain: vivianweidai.com
├── curriculum/             # Curriculum page + NOTES PDFs
├── olympiads/              # Olympiads page (renders from archives/truth/*.json)
├── research/               # Research projects
│   ├── index.md            # Research landing with tabbed project table
│   ├── archives/           # Background reference materials (see REFERENCE MATERIALS)
│   │   ├── toys/           # Instrument list, lab/faculty catalogues
│   │   ├── guides/         # Instrument walk-up guides
│   │   ├── papers/         # Classic papers
│   │   └── photos/         # Reference photos
│   └── projects/           # Individual projects
│       └── YYYYMMDD Project/   # (see below)
└── archives/               # Shared assets (all subfolders lowercase)
    ├── apple/              # iOS + watchOS app (read-only consumer of archives/truth/*.json)
    │   ├── Package.swift   # SwiftPM: ScienceCore + ScienceCoreUI libraries
    │   ├── project.yml     # XcodeGen spec for Science (iOS) + ScienceWatch (watchOS)
    │   ├── shared/Core/    # Platform-neutral Models, API, Grouping, SubjectPaletteRGB
    │   ├── shared/UI/      # iOS-only Views + KaTeX MarkdownWebView
    │   ├── ios/            # @main for iPhone/iPad target
    │   └── watch/          # @main + views for watchOS companion (olympiads-only)
    ├── chinese/            # Chinese-language mirror of the public pages
    ├── truth/              # Science content: YAML source + generated JSON
    │   ├── olympiads.yml / toys.yml                       # Edit these, then rebuild
    │   └── olympiads.json / toys.json / curriculum.json   # Generated — DO NOT EDIT BY HAND
    ├── layout/             # CSS, JS, build scripts, and presentation assets
    │   ├── base.css / tabs.css / curriculum.css
    │   ├── curriculum.js / shuffle.js / tabs.js
    │   ├── favicon.svg / cat.svg / spikey.png   # Icons
    │   ├── science.jpeg / curriculum.png         # Hero images
    │   ├── build_olympiads.py            # truth/*.yml → truth/*.json
    │   └── build_curriculum.py          # curriculum/content/*.md → truth/curriculum.json
    └── privacy/            # Privacy policy page
```

**Activities workflow:** `archives/truth/olympiads.yml` is the single source of truth for all olympiads and textbooks. After editing, run `python archives/layout/build_olympiads.py` to regenerate `archives/truth/olympiads.json`, then commit both the YAML and the JSON. GitHub Pages builds Jekyll natively in "Deploy from a branch" mode and redeploys within ~1 minute of a push — no CI workflow, so it's on the editor to remember the rebuild step. Both the webapp (`olympiads/index.md` via client-side JS) and the Apple apps (`archives/apple/shared/Core/API/APIClient.swift`) fetch the JSON directly — there is no database, no API, no admin endpoint.

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

## LOCAL PREVIEWS (scratchpad)

Use this workflow whenever the user asks to see something rendered — "show me", "preview", "give me choices", design comps — AND also as the default verification step after any change that's observable in the browser (a page edit, CSS tweak, new asset, etc.). The user works locally and reviews in Safari before committing.

- **Location:** all preview/scratchpad work — one-off HTML comps and Jekyll-layout mockups — lives in `science/scratch/`. The folder is gitignored so nothing here is ever committed. Don't create parallel scratchpad folders (e.g. `research/mockup/`, `draft/`, `preview/`) — consolidate into `scratch/`.
- **File shapes:** plain HTML (`scratch/<topic>.html`) for self-contained design comps, or a Jekyll-frontmatter page (`scratch/<topic>/index.md` with `layout: default`) when the mockup needs to pull in site styles or data.
- **Serving:** the Jekyll preview (`.claude/launch.json` → `science-jekyll`, port 4321) serves the whole `science/` tree, so `scratch/` files are reachable at `http://127.0.0.1:4321/scratch/...`. Start it with `preview_start` (name: `science-jekyll`) if it's not already running. Jekyll's compiled output is written to `scratch/_site/` (also gitignored via `scratch/`) — all preview-related artifacts stay inside `scratch/`.
- **Showing the user — default is Safari.** After a change, open the relevant URL in Safari (`open -a Safari 'http://127.0.0.1:4321/<path>'`) so the user sees the real rendering natively. Do not default to the in-IDE preview viewer or to `qlmanage` thumbnails. `qlmanage -t -s 1200 -o /tmp <file>.html` is only an inline-in-chat fallback if you need to show the user something without switching apps.
- **Promoting to the site:** if the user picks an option and wants it live, move the chosen asset into the appropriate tracked path (e.g. `archives/layout/`, `archives/truth/`, or a project's `output/`). Never commit from `scratch/`.

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

Existing pages that model this style: `20260415 IR Spectroscopy/index.md` and `20260417 UV-Vis Spectroscopy/index.md`. When adding a new project or revising an old one, aim for their level of density.

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
- **Always resize images before committing.** No image may be committed over ~500 KB or wider than 1600 px — resize it first (`sips -Z 1600 -s formatOptions 82 file.jpeg --out file.jpeg`). The 1600 px cap is intentional for this repo: photos here are decorative illustrations inside research reports, not hero content that readers zoom into. (Compare: `domains/` uses 2560 px because it serves full-screen wallpapers where retina sharpness matters. Different caps, different jobs.) For photos saved as PNG without transparency, convert to JPEG (`sips -s format jpeg`) and update every markdown reference. For PNGs with transparency that must stay PNG, run `pngquant --quality=65-85 --ext .png --force file.png`. This rule applies to **all** directories including `data/` and `photos/` — "never modify raw data files" refers to analysis outputs, not repo hygiene. **Before every commit**, run `find . -type f \( -iname '*.jpg' -o -iname '*.jpeg' -o -iname '*.png' \) -size +500k -not -path './.git/*' -not -path './_site/*'` and shrink anything that surfaces.
- **Always compress PDFs before committing.** No PDF may be committed over ~5 MB without a real reason — instrument manuals and academic papers come in fat by default and bloat git history forever. Use Ghostscript (`gs -sDEVICE=pdfwrite -dPDFSETTINGS=/ebook -dNOPAUSE -dQUIET -dBATCH -sOutputFile=out.pdf in.pdf`); use `/screen` (72 DPI) for huge image-heavy manuals, `/ebook` (150 DPI) when text fidelity matters. Always **verify a mid-document page renders** after compression (`pdftoppm -r 60 -f 50 -l 50 out.pdf /tmp/check`) — some sources have parser-broken streams that silently produce blank pages. **Before every commit**, run `find . -type f -iname '*.pdf' -size +5M -not -path './.git/*' -not -path './_site/*'` and shrink anything that surfaces.
- **Photos:** If a project has 4+ photos, use the 2x2 photo grid with shuffle button. **The shuffle pool is auto-populated by the `project.html` layout** — it scans every `.jpg`/`.jpeg`/`.png` file under the project's `photos/` subtree (both `photos/setup/` and `photos/samples/`) and injects them as `window._pagePhotos`. Do not list photos in front matter; do not add a per-page `<script>var _pagePhotos = ...</script>` line. Just include the `<div class="photo-grid">` + `<button class="shuffle-btn">` markup and the `<script src="/archives/layout/shuffle.js"></script>` tag. The page gets every new photo automatically when you drop it into the right folder. If a project has only 1 photo, use a single hero image with `<div class="hero-single">` for rounded styling and controlled height.
- **Date/Instrument metadata** should be right-aligned below the photos using `<div class="project-meta">`. Put Instrument on a new line with `<br>`.
- **Results links** should point to the GitHub blob URL (e.g. `https://github.com/vivianweidai/science/blob/main/...`) so files render inside GitHub.
- Ensure all code, data, and documentation is presentable and well-organized.
- Each project's `index.md` (not README.md) serves as the public-facing overview — Jekyll requires `index.md` for subdirectory pages.
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
