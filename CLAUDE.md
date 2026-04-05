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
- **Visualizations** — default to matplotlib/seaborn. Use clear axis labels, units, titles, and legends. Save figures as both PNG (300 dpi) and SVG.
- **Reproducibility** — every analysis script should be runnable end-to-end from the project folder. Include comments explaining what each step does and why. Pin library versions in a `requirements.txt` if the pipeline uses non-standard packages.
- **Data validation** — always inspect and summarize raw data before analysis (shape, missing values, outliers, units). Flag anything unexpected.

## INSTRUMENTS & DATA FORMATS

Known instruments (expect data from these):
- **FT-IR Spectrometer** — produces CSV files with wavenumber (cm⁻¹) vs. transmittance/absorbance
- **Four-Point Probe (Jandel RM3)** — resistivity measurements
- Additional instruments as projects expand (XRD, SEM, UV-Vis, etc.)

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
  var shuffled = allPhotos.slice().sort(function() { return 0.5 - Math.random(); });
  for (var i = 0; i < 4; i++) {
    document.getElementById('photo-' + i).src = shuffled[i];
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

## Samples

| # | Category | Samples |
|---|----------|---------|
| 1 | [Category] | [sample1, sample2] |

## Data

Raw data files are in `DATA/`. [Describe format.]

## Methods

1. [Step-by-step procedure]

## Results

[Summary. Link to analysis/report on GitHub:]

See the <a href="https://github.com/vivianweidai/research/blob/main/[URL-encoded path]">full reproducible analysis</a> (Jupyter notebook) or the <a href="https://github.com/vivianweidai/research/blob/main/[URL-encoded path]">written report</a> (PDF).

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/[URL-encoded folder name]">View on GitHub</a></div>
```

Always use `index.md` (not `README.md`) for project pages. Always include the footer div.
