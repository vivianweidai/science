# RESEARCH — Claude Code Instructions

## BACKGROUND

James (CS: BSc UBC, MSc MIT, current MSc UNR; business: Stanford Executive Program) and his daughter Vivian (Grade 7, Davidson Academy, dual-enrolled at UNR) are conducting university-level research across six science olympiad disciplines: Mathematics, Computing, Physics, Chemistry, Biology, and Astronomy. They have 24/7 independent access to the UNR Shared Instruments Laboratory (Room 016, Chemistry Building).

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
│   ├── FIGURES/            # Generated plots and visualizations
│   └── *.csv / *.json      # Processed/cleaned data
├── README.md               # Project overview, methods, results summary
```

- **Subfolder naming convention: ALL CAPS** (e.g., `DATA/`, `OUTPUT/`, `FIGURES/`).
- **Never modify raw data files.** Read from `DATA/`; write all generated outputs to `OUTPUT/`.
- Create subdirectories (`DATA/`, `PHOTOS/`, `PAPERS/`, `OUTPUT/`, `OUTPUT/FIGURES/`) as needed when setting up or processing a project.
- When a final report or summary PDF is needed, also save a copy to the parent `SCIENCE/OUTPUT/` folder.

## ANALYSIS GUIDELINES

- **Tool choice is flexible** — use Python, R, Julia, shell scripts, or whatever fits the task best. Default to Python scientific stack (pandas, numpy, scipy, matplotlib, seaborn) when there's no strong reason to pick something else.
- **Visualizations** — default to matplotlib/seaborn. Use clear axis labels, units, titles, and legends. Save figures as both PNG (300 dpi) and SVG.
- **Reproducibility** — every analysis script should be runnable end-to-end from the project folder. Include comments explaining what each step does and why. Pin library versions in a `requirements.txt` if the pipeline uses non-standard packages.
- **Data validation** — always inspect and summarize raw data before analysis (shape, missing values, outliers, units). Flag anything unexpected.

## INSTRUMENTS & DATA FORMATS

Known instruments at the UNR SIL (expect data from these):
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
- Ensure all code, data, and documentation is presentable and well-organized.
- Each project's `README.md` serves as the public-facing overview of that experiment.
