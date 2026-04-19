---
layout: project
project: UV-Vis Spectroscopy
---

<div class="page-header"><h2>Research</h2><div class="header-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div></div>

<div class="project-title"><h1>UV-Vis Spectroscopy of Everyday Fluorophores</h1><span class="chip chem">Chemistry</span></div>

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="Experiment photo">
  <img id="photo-1" alt="Experiment photo">
  <img id="photo-2" alt="Experiment photo">
  <img id="photo-3" alt="Experiment photo">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">Shuffle Photos</button>

<script src="/archives/layout/shuffle.js"></script>

<div class="section-heading"><h2>Overview</h2><span class="section-date">April 17th 2026</span></div>

One set of samples, three instruments, three questions:

- **UV-2550** — which colors of light the compound swallows, and how greedily.
- **FluoroMax-3** — which colors come back out again driven by which absorption.
- **Lambda 750** — which solvents.

The samples are all fluorophores: molecules that catch a photon and release a longer-wavelength one. The gap between the two peaks is the **Stokes shift**, and it's what makes this experiment interesting — the return photon is never quite the one that went in. Everyday sources stand in for lab references: quinine from tonic water, fluorescein and rhodamine dyes from highlighter ink, curcumin from turmeric, chlorophyll from green tea, salicylate from aspirin.

## Setup

<style>.instrument-table tbody tr td { background: #fff44f; }</style>

<div class="instrument-table" markdown="1">

| Instrument | Role | Range |
|------------|------|-------|
| Shimadzu UV-2550 UV/Vis Spectrophotometer | Absorption (λ<sub>max</sub>) | 200–800 nm |
| Horiba Jobin Yvon FluoroMax-3 Spectrofluorometer | Fluorescence (emission and excitation) | 200–800 nm |
| PerkinElmer Lambda 750 UV/Vis/NIR Spectrophotometer | Solvent (NIR overtones) | 200–2500 nm |

</div>

| Toolkit | Details |
|----------|---------|
| Cuvettes | Fluorescence-grade 10 mm quartz with four clear sides |
| Software | UVProbe (Shimadzu), FluorEssence (Horiba), UV WinLab (PerkinElmer) |
| Blanks | Distilled water (aqueous samples), 95% ethanol (ethanol samples) |

Cuvette protocol (same on every instrument): 3× distilled water, 1× ethanol, 1× water, Kimwipe polish each optical face, gripped only at the top rim with ceramic tweezers. Each sample pre-rinses its cuvette with itself before the keeper fill.

## Samples

<div class="hero-single"><img src="photos/samples/samples3.jpeg" alt="Eight labeled amber stock bottles — six fluorophore samples plus two blank solvents"></div>

Six fluorophores plus two blanks, split by solvent. The grouping is also the scan order: four water samples first against a water baseline, then re-baseline and run the two ethanol extracts. Each sample is prepared from an everyday source: quinine from de-gassed tonic water, fluorescein- and rhodamine-family dyes from highlighter ink reservoirs, curcumin and chlorophyll from turmeric and green tea extracted into ethanol, salicylate from aspirin hydrolyzed with a pinch of baking soda.

<style>
  .samples-tabs #s-water:checked ~ .tab-labels label[for="s-water"],
  .samples-tabs #s-ethanol:checked ~ .tab-labels label[for="s-ethanol"] {
    color: #5c7a10; border-bottom-color: #5c7a10; background: var(--subj-chem);
  }
  .samples-tabs #s-water:checked ~ #content-s-water,
  .samples-tabs #s-ethanol:checked ~ #content-s-ethanol {
    display: block;
  }
  .samples-tabs table { width: 100%; }
</style>

<div class="tabs samples-tabs">
  <input type="radio" name="samples-tab" id="s-water" checked>
  <input type="radio" name="samples-tab" id="s-ethanol">

  <div class="tab-labels">
    <label for="s-water">Water-based</label>
    <label for="s-ethanol">Ethanol-based</label>
  </div>

  <div class="tab-content" id="content-s-water" markdown="1">

| Category | Sample |
|----------|--------|
| Antimalarial | quinine (tonic water, degassed) |
| Fluorescent dye | yellow highlighter (fluorescein-family) |
| Fluorescent dye | pink highlighter (rhodamine-family) |
| Pharmaceutical | salicylate (aspirin + NaHCO₃) |
| Blank | distilled water |

  </div>

  <div class="tab-content" id="content-s-ethanol" markdown="1">

| Category | Sample |
|----------|--------|
| Natural pigment | curcumin (turmeric + ethanol) |
| Natural pigment | green tea extract (tea leaves + ethanol) |
| Blank | 95% ethanol |

  </div>
</div>

## Methods

Same samples, three instruments in sequence. The UV-2550 run feeds the FluoroMax: its λ<sub>max</sub> sets FluoroMax's λ<sub>ex</sub>, and its peak absorbance sets the dilution factor D = A / 0.05.

<style>
  .methods-tabs #m-uv:checked ~ .tab-labels label[for="m-uv"],
  .methods-tabs #m-flu:checked ~ .tab-labels label[for="m-flu"],
  .methods-tabs #m-lam:checked ~ .tab-labels label[for="m-lam"] {
    color: #5c7a10; border-bottom-color: #5c7a10; background: var(--subj-chem);
  }
  .methods-tabs #m-uv:checked ~ #content-m-uv,
  .methods-tabs #m-flu:checked ~ #content-m-flu,
  .methods-tabs #m-lam:checked ~ #content-m-lam {
    display: block;
  }
  .methods-tabs table { width: 100%; }
  .methods-tabs td:first-child, .methods-tabs th:first-child { width: 2.5em; text-align: center; }
</style>

<div class="tabs methods-tabs">
  <input type="radio" name="methods-tab" id="m-uv" checked>
  <input type="radio" name="methods-tab" id="m-flu">
  <input type="radio" name="methods-tab" id="m-lam">

  <div class="tab-labels">
    <label for="m-uv"><span class="label-full">UV-2550</span><span class="label-abbr">UV-2550</span></label>
    <label for="m-flu"><span class="label-full">FluoroMax-3</span><span class="label-abbr">FluoroMax</span></label>
    <label for="m-lam"><span class="label-full">Lambda 750</span><span class="label-abbr">Lambda 750</span></label>
  </div>

  <div class="tab-content" id="content-m-uv" markdown="1">

| # | Sample | Dilution |
|---|--------|----------|
| 1 | *baseline — distilled water* | — |
| 2 | blank (distilled water) — confirm ~0 A | — |
| 3 | quinine | About 3 times |
| 4 | yellow HL | About 3 times |
| 5 | pink HL | About 3 times |
| 6 | salicylate | About 3 times |
| 7 | *re-baseline — 95% ethanol* | — |
| 8 | blank (95% ethanol) — confirm ~0 A | — |
| 9 | curcumin | About 3 times |
| 10 | green tea | About 3 times |

One absorption scan per sample, 190–800 nm produces λ<sub>max</sub> and A at peak. Each baseline is followed by a blank scanned as a sample: it should come back flat near zero, confirming the baseline took before real samples run. Most stocks need heavy dilution to land in the 0.3–0.8 A sweet spot — each iteration keeps one drop of the previous stock and tops up with fresh solvent until the peak falls in range.

  </div>

  <div class="tab-content" id="content-m-flu" markdown="1">

| # | Sample | Expected λ<sub>ex</sub> | Expected λ<sub>em</sub> |
|---|--------|------|------|
| 1 | *baseline — distilled water* | — | — |
| 2 | blank (distilled water) — confirm flat | — | — |
| 3 | quinine | 350 | 450 |
| 4 | salicylate | 300 | 410 |
| 5 | *re-baseline — 95% ethanol* | — | — |
| 6 | blank (95% ethanol) — confirm flat | — | — |
| 7 | green tea | 430 | 670 |
| 8 | curcumin | 425 | 540 |
| 9 | *switch to "dyes" cuvette + re-baseline distilled water* | — | — |
| 10 | blank (distilled water) — confirm flat | — | — |
| 11 | yellow HL | 488 | 515 |
| 12 | pink HL | 540 | 585 |

Two scans per sample on aliquots diluted to D = A / 0.05 (add D drops of solvent per drop of sample). Emission scan fixes λ<sub>ex</sub> (from the UV-2550 λ<sub>max</sub>) and sweeps emission. Excitation scan fixes λ<sub>em</sub> and sweeps excitation. Samples run dilute → concentrated to avoid carryover between reads. An Excitation–Emission Matrix (EEM) scan is run on **green tea extract** and **pink highlighter** — the two samples most likely to be mixtures of multiple fluorophores (chlorophyll a + b + polyphenols in green tea; rhodamine-family dye blends in the ink). The EEM sweeps both λ<sub>ex</sub> and λ<sub>em</sub> to produce a 2D contour fingerprint that the single-ex / single-em scans above would collapse.

  </div>

  <div class="tab-content" id="content-m-lam" markdown="1">

| # | Sample |
|---|--------|
| 1 | distilled water blank |
| 2 | 95% ethanol blank |

One pass per solvent, 800–2500 nm — the range no other instrument reaches. Water shows O–H overtones at ~970, 1200, 1450, 1940 nm; ethanol adds C–H overtones at ~1400, 1700 nm. A brief 200–800 nm rescan on each of the six UV-2550 fluorophore samples doubles as a calibration check — peak positions should agree with the UV-2550 within ~1 nm.

  </div>
</div>

## Data

| Instrument | Files per run |
|------------|---------------|
| UV-2550 | 8 — 6 samples + 2 blanks |
| FluoroMax-3 | 20 — 2 scans (EM + EX) × (6 samples + 3 blanks) + 2 EEM |
| Lambda 750 | 10 — 6 UV-Vis rescans + 2 NIR blanks + 2 bonus NIR samples |

*Session results pending.*

## Results

### UV-Vis Absorption - UV-2550

<div class="tabs">
  <input type="radio" name="uv-tab" id="uv-overlay" checked>
  <input type="radio" name="uv-tab" id="uv-curcumin">
  <input type="radio" name="uv-tab" id="uv-yellow-neat">
  <input type="radio" name="uv-tab" id="uv-pink">
  <input type="radio" name="uv-tab" id="uv-greentea">

  <div class="tab-labels">
    <label for="uv-overlay">Overlay</label>
    <label for="uv-curcumin">Curcumin</label>
    <label for="uv-yellow-neat">Yellow HL</label>
    <label for="uv-pink">Pink HL</label>
    <label for="uv-greentea">Green tea</label>
  </div>

  <div class="tab-content" id="content-uv-overlay">
    <img src="output/images/uvvis_overlay.png" alt="UV-Vis overlay" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-curcumin">
    <img src="output/images/uvvis_curcumin.png" alt="Curcumin UV-Vis spectrum" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-yellow-neat">
    <img src="output/images/uvvis_yellow_neat.png" alt="Yellow highlighter neat UV-Vis spectrum" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-pink">
    <img src="output/images/uvvis_pink.png" alt="Pink highlighter UV-Vis spectrum" class="result-img">
  </div>
  <div class="tab-content" id="content-uv-greentea">
    <img src="output/images/uvvis_greentea.png" alt="Green tea UV-Vis spectrum" class="result-img">
  </div>
</div>

*Per-sample commentary forthcoming.*

### Fluorescence - FluoroMax-3

<img src="output/images/fluoromax_yellow.png" alt="Yellow highlighter excitation and emission spectra">

*Description forthcoming.*

### Solvent - Lambda 750

*Forthcoming.*
