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
- **Each project README must start with a 2x2 photo grid** that randomly selects 4 photos from the `PHOTOS/` directory on each page load, with a "Shuffle Photos" button. List all photos in the front matter `photos` array. The `project.html` layout provides the CSS for `.photo-grid` and `.shuffle-btn`.
- Ensure all code, data, and documentation is presentable and well-organized.
- Each project's `README.md` serves as the public-facing overview of that experiment.

## PROJECT README TEMPLATE

When creating a new project README, use this template:

```markdown
---
layout: project
project: [Short Project Name]
photos:
  - PHOTOS/[filename1].jpeg
  - PHOTOS/[filename2].jpeg
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

**Date:** [Month Dayth Year, e.g. April 4th 2026]
**Instrument:** [Full instrument name, e.g. Thermo Scientific Nicolet iS5 FT-IR Spectrometer]

## Overview

[1-2 paragraph description of the experiment: what was measured, why, and the key question being investigated.]

## Samples

[Group samples by category to keep the table concise — no more than 7 rows.]

| # | Category | Samples |
|---|----------|---------|
| 1 | [Category] | [sample1, sample2, sample3] |

## Data

Raw data files are in `DATA/`. [Describe format: columns, units, number of data points, file naming convention.]

## Methods

1. [Step-by-step experimental procedure]

## Results

[Analysis summary. If a written report PDF exists in OUTPUT/, link to it:]

See the <a href="OUTPUT/[filename].pdf">full written report</a>.

## References

- See `PAPERS/` for background literature

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/[URL-encoded folder name]">View on GitHub</a></div>
```

Always include the footer div at the bottom of every project README with links to Curriculum, Olympiads, Research, and View on GitHub.
