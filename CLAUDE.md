# RESEARCH — Claude Code Instructions

## YOUR ROLE

You are a research data analyst and pipeline builder. Your primary jobs are:

1. **Process experimental data** — parse raw instrument outputs (CSVs, spectra, images), clean and validate data, perform statistical analysis, and generate publication-quality visualizations.
2. **Build reproducible pipelines** — create reusable scripts that can be re-run on new data with minimal modification. Each experiment should have a clear, repeatable analysis workflow.

## PROJECT STRUCTURE

Each research project lives in a date-prefixed folder:

```
YYYYMMDD Project Name/
├── DATA/                   # Raw data from instruments (CSVs, spectra, etc.)
├── PHOTOS/                 # Experiment photos (YYYYMMDD format filenames)
├── PAPERS/                 # Background reference papers
├── OUTPUT/                 # Analysis output: scripts, notebooks, figures, processed data
│   ├── *.py / *.ipynb      # Analysis code
│   ├── *.png               # Generated plots and visualizations
│   └── *.csv / *.json      # Processed/cleaned data
├── README.md               # Project overview, methods, results summary
```

- **Subfolder naming convention: ALL CAPS** (e.g., `DATA/`, `OUTPUT/`).
- **Never modify raw data files.** Read from `DATA/`; write all generated outputs to `OUTPUT/`.
- Create subdirectories (`DATA/`, `PHOTOS/`, `PAPERS/`, `OUTPUT/`) as needed when setting up or processing a project.
- When a final report or summary PDF is needed, also save a copy to the parent `SCIENCE/OUTPUT/` folder.

## ANALYSIS GUIDELINES

- **Tool choice is flexible** — use Python, R, Julia, shell scripts, or whatever fits the task best. Default to Python scientific stack (pandas, numpy, scipy, matplotlib, seaborn) when there's no strong reason to pick something else.
- **Visualizations** — default to matplotlib/seaborn. Use clear axis labels, units, titles, and legends. Save figures as PNG (300 dpi).
- **Reproducibility** — every analysis script should be runnable end-to-end from the project folder. Include comments explaining what each step does and why. Pin library versions in a `requirements.txt` if the pipeline uses non-standard packages.
- **Data validation** — always inspect and summarize raw data before analysis (shape, missing values, outliers, units). Flag anything unexpected.
- **Jupyter notebook conventions:**
  - **Colab compatibility** — all data file references must use absolute GitHub raw URLs (e.g., `https://raw.githubusercontent.com/vivianweidai/research/main/...`) so notebooks work in Colab. Ship notebooks **with outputs** so GitHub renders results statically; Colab users re-run themselves.
  - **Sections** — use numbered markdown heading cells (`## 1. Title`, `## 2. Title`, etc.) to separate logical sections. Typical flow: Data Collection → Load and Inspect Data → Visualize → Statistical Test → Conclusion.
  - **Output styling** — use plain `print()` for text output. Keep code tight and minimal — no HTML boxes, no `IPython.display`, no extra spacing hacks.
  - **Chart styling** — use matplotlib defaults (no custom fonts, no facecolor overrides). Use soft, muted pastels for colours — reference palette: pink `#f8d7da`, green `#d4edda`, blue `#cce5ff`, yellow `#fff3cd`, purple `#e2d9f3`, orange `#fce4b8`. For data line traces use slightly deeper tones like `#d95f5f`. Always keep colours light and airy — never saturated or bold. Save as PNG (300 dpi). If a project produces many images, save into an `OUTPUT/IMAGES/` subfolder; if only one or two images, save directly into `OUTPUT/`.
  - **Colab badge** — add a final markdown cell with `---` separator, then just the Colab badge image link (no descriptive text): `<a href="COLAB_URL"><img src="https://colab.research.google.com/assets/colab-badge.svg" alt="Open In Colab" style="vertical-align:middle;"></a>`

## SCIENCE PROJECT REFERENCE

The shared SCIENCE project folder at `/Users/jamesdai/CLAUDE/SCIENCE/` contains comprehensive reference materials. Read these files as needed for instrument details, available equipment, curriculum context, and research planning:

- **`CONTEXT/UNR_Toy_List.pdf`** — master list of 35 instruments across 4 sciences (Biology, Chemistry, Mathematics, Computing) available at UNR SIL Room 016
- **`CONTEXT/University_Technology_Landscape.xlsx`** — 5-sheet comparison of UNR vs UBC vs MIT vs Caltech (105 technology sub-categories, SIL coverage analysis)
- **`CONTEXT/UNR_SIL_Instrument_Inventory.xlsx`** — detailed SIL instrument inventory
- **`CONTEXT/UNR_SIL_Lab_Guide.pdf`** — lab access and procedures
- **`CONTEXT/UNR_SIL_Technique_Map.pdf`** — technique-to-instrument mapping
- **`CONTEXT/UNR_Faculty_Catalogue_Updated.xlsx`** — UNR faculty research areas
- **`CONTEXT/UNR_Labs_Catalogue_Updated.xlsx`** — UNR lab catalogue
- **Instrument walk-up guides** — `DSC_Q100_WalkUp_Guide.pdf`, `DSC_Q20_WalkUp_Guide.pdf`, `TGA_Q50_WalkUp_Guide.pdf`, `CONTEXT/FT-IR_Quick_Start_Guide.pdf`, `CONTEXT/FT-IR_Spectral_Analysis.pdf`, `CONTEXT/Jandel_RM3_Four_Point_Probe_Guide.pdf`, `CONTEXT/OptiMelt_WalkUp_Guide.pdf`
- **Curriculum notes** — `CONTEXT/NOTES *.pdf` (Astronomy, Biology, Chemistry, Computing, Mathematics, Physics)
- **Classic papers** — `CONTEXT/PAPER *.pdf` (Turing, Rosenblatt, Hubel & Wiesel, Q-Learning, Transformers, AlphaGo, etc.)
- **UBC references** — `CONTEXT/UBC_Faculty_Catalogue.xlsx`, `CONTEXT/UBC_Vancouver_Research_Opportunities.pdf`
- **General** — `CONTEXT/CONTEXT Overview.pdf`, `CONTEXT/CONTEXT Books.pdf`, `CONTEXT/CONTEXT Guide.pdf`, `CONTEXT/CONTEXT Workflow.pdf`, `CONTEXT/Science_Competitions_Guide.pdf`, `CONTEXT/University_Shared_Labs.pdf`

## INSTRUMENTS & DATA FORMATS

35 instruments are available at UNR SIL (see `CONTEXT/UNR_Toy_List.pdf` for full list). Instruments used so far:
- **Thermo Scientific Nicolet 380 FT-IR Spectrometer** — CSV files with wavenumber (cm⁻¹) vs. transmittance/absorbance
- **Jandel RM3-AR Four-Point Probe** — sheet resistance measurements (Ω/□)
- **SRS OptiMelt Melting Point System** — non-functional (touchscreen unresponsive)
- **Next up: TA Instruments Q50 TGA** — thermogravimetric analysis (walk-up guide available)

## SUPPLIES & LOGISTICS

- All consumables and supplies are ordered from Amazon (not university Chemstore).
- Nothing is stored at the lab — assume all materials are walked in each session.
- Operate independently: no training sessions with lab staff, minimal contact.

## GITHUB & VISIBILITY

This RESEARCH folder is synced to GitHub. Everything inside each project folder is publicly viewable. Keep this in mind:
- Do not commit sensitive or personal information.
- **Never include researcher names or lab location in READMEs or any public-facing files.** Project READMEs should include Date and Instrument but not Researchers or Location.
- **Photos:** If a project has 4+ photos, use the 2x2 photo grid with shuffle button (list all photos in front matter `photos` array). If a project has only 1 photo, use a single hero image with `<div class="hero-single">` for rounded styling and controlled height. The `project.html` layout provides CSS for both `.photo-grid`, `.shuffle-btn`, and `.hero-single`.
- **Date/Instrument metadata** should be right-aligned below the photos using `<div class="project-meta">`. Put Instrument on a new line with `<br>`.
- **Results links** should point to the GitHub blob URL (e.g. `https://github.com/vivianweidai/research/blob/main/...`) so files render inside GitHub.
- Ensure all code, data, and documentation is presentable and well-organized.
- Each project's `index.md` (not README.md) serves as the public-facing overview — Jekyll requires `index.md` for subdirectory pages.
- **When creating a new project**, always add it to the tabbed project table in the root `README.md` under the appropriate discipline tab (Mathematics, Computing, Physics, Chemistry, Biology, Astronomy). Also add any new instruments to the Instruments section in `README.md`.

## PROJECT README TEMPLATE

When creating a new project README, use this template:

### Template A: Multiple photos (4+)

```markdown
---
layout: project
project: [Short Project Name]
photos:
  - PHOTOS/[filename1].jpeg
  - PHOTOS/[filename2].jpeg
  - PHOTOS/[filename3].jpeg
  - PHOTOS/[filename4].jpeg
---

# [Experiment Title]

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="Experiment photo">
  <img id="photo-1" alt="Experiment photo">
  <img id="photo-2" alt="Experiment photo">
  <img id="photo-3" alt="Experiment photo">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">Shuffle Photos</button>

<script>
var allPhotos = {{ page.photos | jsonify }};
function shufflePhotos() {
  var a = allPhotos.slice();
  for (var i = a.length - 1; i > 0; i--) {
    var j = Math.floor(Math.random() * (i + 1));
    var t = a[i]; a[i] = a[j]; a[j] = t;
  }
  for (var i = 0; i < 4; i++) {
    document.getElementById('photo-' + i).src = a[i];
  }
}
shufflePhotos();
</script>

<div class="project-meta">[Month Dayth Year]<br>[Instrument name]</div>
```

### Template B: Single photo

```markdown
---
layout: project
project: [Short Project Name]
---

# [Experiment Title]

<div class="hero-single"><img src="PHOTOS/[filename]" alt="[description]"></div>

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

[Description of samples. Do NOT include a "#" numbering column in sample tables.]

## Data

[Description of data format and what was recorded.]

[If DATA/ contains photos/images, add a photo grid here using `data_photos` front matter. Show all photos without a shuffle button if count <= 4. Only add shuffle button if there are more photos than grid slots. Use `three-col` class for 3 images. This grid is independent from the top PHOTOS shuffler.]

## Results

[Summary. Link to written report first, then notebook:]

See the <a href="https://github.com/vivianweidai/research/blob/main/[path]">written report</a>, the <a href="https://github.com/vivianweidai/research/blob/main/[path]">static notebook</a> or <a href="https://colab.research.google.com/github/vivianweidai/research/blob/main/[path]">run the reproducible analysis yourself</a>.

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/[URL-encoded folder name]">View on GitHub</a></div>
```

Always use `index.md` (not `README.md`) for project pages. Always include the footer div. The `photos` front matter array is for PHOTOS/ only; use `data_photos` for DATA/ images. **Samples** is a top-level `##` section (not a subsection of Setup). Never include a `#` numbering column in tables.
