---
project: UV-Vis Spectroscopy
---


<div class="project-title"><h1>UV-Vis Spectroscopy of Everyday Fluorophores</h1><a class="chip chem" href="/curriculum/#chemistry">Chemistry</a></div>

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="Experiment photo">
  <img id="photo-1" alt="Experiment photo">
  <img id="photo-2" alt="Experiment photo">
  <img id="photo-3" alt="Experiment photo">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">Shuffle Photos</button>

<div class="section-heading"><h2>Overview</h2><span class="section-date">April 20th 2026</span></div>

One set of samples through two instruments:

- **UV-2550** — which colors of light the compound swallows, and how greedily.
- **FluoroMax-3** — which colors come back out again driven by which absorption.

The samples are all **fluorophores**: molecules that catch a photon and release a longer-wavelength one. The gap between the two peaks is the **Stokes shift** — the return photon is never quite the one that went in. Everyday sources stand in for lab references: quinine from tonic water, fluorescein and rhodamine dyes from highlighter ink, curcumin from turmeric, chlorophyll from green tea, salicylate from aspirin.

## Setup

<div class="photo-grid">
  <img src="photos/setup/setup2.jpeg" alt="Shimadzu UV-2550 UV/Vis Spectrophotometer">
  <img src="photos/setup/setup8.jpeg" alt="Horiba Jobin Yvon FluoroMax-3 Spectrofluorometer">
</div>

<div class="instrument-table">

| Instrument | Role | Range |
|------------|------|-------|
| Shimadzu UV-2550 UV/Vis Spectrophotometer | Absorption (λ<sub>max</sub>) | 200–800 nm |
| Horiba Jobin Yvon FluoroMax-3 Spectrofluorometer | Fluorescence (emission and excitation) | 200–800 nm |

</div>

| Toolkit | Details |
|----------|---------|
| Cuvettes | Fluorescence-grade 10 mm quartz with four clear sides |
| Software | UVProbe (Shimadzu), FluorEssence (Horiba) |
| Blanks | Distilled water (aqueous samples), 95% ethanol (ethanol samples) |

Cuvette protocol (same on every instrument): 3× distilled water, 1× ethanol, 1× water, Kimwipe polish each optical face, gripped only at the top rim with ceramic tweezers. Each sample pre-rinses its cuvette with itself before the keeper fill.

## Samples

<div class="hero-single"><img src="photos/samples/samples3.jpeg" alt="Eight labeled amber stock bottles — six fluorophore samples plus two blank solvents"></div>

Six fluorophores plus two blanks, split by solvent. The grouping is also the scan order: four water samples first against a water baseline, then re-baseline and run the two ethanol extracts. Each sample is prepared from an everyday source: quinine from de-gassed tonic water, fluorescein- and rhodamine-family dyes from highlighter ink reservoirs, curcumin and chlorophyll from turmeric and green tea extracted into ethanol, salicylate from aspirin hydrolyzed with a pinch of baking soda.

<div class="tabs samples-tabs">
  <input type="radio" name="samples-tab" id="s-water" checked>
  <input type="radio" name="samples-tab" id="s-ethanol">

  <div class="tab-labels">
    <label for="s-water">Water-based</label>
    <label for="s-ethanol">Ethanol-based</label>
  </div>

  <div class="tab-content" id="content-s-water">

| Category | Sample |
|----------|--------|
| Antimalarial | quinine (tonic water, degassed) |
| Fluorescent dye | yellow highlighter (fluorescein-family) |
| Fluorescent dye | pink highlighter (rhodamine-family) |
| Pharmaceutical | salicylate (aspirin + NaHCO₃) |
| Blank | distilled water |

  </div>

  <div class="tab-content" id="content-s-ethanol">

| Category | Sample |
|----------|--------|
| Natural pigment | curcumin (turmeric + ethanol) |
| Natural pigment | green tea extract (tea leaves + ethanol) |
| Blank | 95% ethanol |

  </div>
</div>

## Method

The UV-2550 scan yields λ<sub>max</sub> (peak wavelength) and A (peak absorbance). Both feed the FluoroMax: λ<sub>max</sub> sets λ<sub>ex</sub>, and A sets the dilution factor D = A / 0.05 — the FluoroMax needs samples diluted to A ≈ 0.05 to avoid inner-filter effects.

<div class="tabs methods-tabs">
  <input type="radio" name="methods-tab" id="m-uv" checked>
  <input type="radio" name="methods-tab" id="m-flu">

  <div class="tab-labels">
    <label for="m-uv"><span class="label-full">UV-2550</span><span class="label-abbr">UV-2550</span></label>
    <label for="m-flu"><span class="label-full">FluoroMax-3</span><span class="label-abbr">FluoroMax</span></label>
  </div>

  <div class="tab-content" id="content-m-uv">

| # | Sample | Final Solute |
|---|--------|----------|
| 1 | *baseline — distilled water* | — |
| 2 | blank (distilled water) — confirm ~0 A | — |
| 3 | quinine | 8 drops |
| 4 | yellow HL | 1 drop |
| 5 | pink HL | ⅙ drop |
| 6 | salicylate | ⅕ of ⅙ drop |
| 7 | *re-baseline — 95% ethanol* | — |
| 8 | blank (95% ethanol) — confirm ~0 A | — |
| 9 | curcumin | upcoming |
| 10 | green tea | upcoming |

One absorption scan per sample across 200–800 nm. Every baseline is immediately followed by the solvent blank rescanned as a sample — it should return flat near zero, confirming the baseline held. Most stocks need heavy dilution to land in the 0.3–0.8 A sweet spot: each sample started at 1 drop of stock in 3 mL of solvent, then was diluted or concentrated iteratively until the peak fell in range.

  </div>

  <div class="tab-content" id="content-m-flu">

| # | Sample | Expected λ<sub>ex</sub> | Expected λ<sub>em</sub> |
|---|--------|------|------|
| 1 | quinine | 350 | 450 |
| 2 | yellow HL | 488 | 515 |
| 3 | pink HL | 540 | 585 |
| 4 | salicylate | 300 | 410 |
| 5 | curcumin | 425 | 540 |
| 6 | green tea | 430 | 670 |

Each sample goes straight from the UV-2550 into the FluoroMax using the final in-range aliquot diluted to D = A / 0.05 (add D drops of solvent per drop of sample). Two scans per sample: emission fixes λ<sub>ex</sub> (from the UV-2550 λ<sub>max</sub>) and sweeps λ<sub>em</sub>; excitation fixes λ<sub>em</sub> and sweeps λ<sub>ex</sub>. An Excitation–Emission Matrix (EEM) scan is planned for **green tea extract** to produce a 2D contour map.

  </div>

</div>

## Data

| Instrument | Files | Coverage |
|------------|-------|----------|
| UV-2550 | 19 `.txt` | baseline, quinine (10), yellow HL (3), pink HL (2), salicylate (3) |
| FluoroMax-3 | 7 `.csv` + 7 `.pdf` | quinine, yellow HL, salicylate — emission + excitation; pink HL — emission only |
| Lambda 750 | 2 `.csv` | exploratory — water sample + baseline |

Water-solvent samples only this session — ethanol block (curcumin, green tea) deferred to a later run. Raw files live under <a href="https://github.com/vivianweidai/science/tree/main/public/research/projects/20260420%20UV-Vis%20Spectroscopy/data" rel="noopener">data</a>. Iterative-dilution filenames preserve the full convergence sequence for each sample in the attempt to land in the 0.3–0.8 A sweet spot. The PDF files retain the machine settings used for the scans.

All UV-Vis, fluorescence, and Lambda 750 plots were generated from the raw data using Python libraries in the analysis <a href="https://github.com/vivianweidai/science/blob/main/public/research/projects/20260420%20UV-Vis%20Spectroscopy/output/uv_spectroscopy.ipynb" rel="noopener">notebook</a> and are reproducible on <a href="https://colab.research.google.com/github/vivianweidai/science/blob/main/public/research/projects/20260420%20UV-Vis%20Spectroscopy/output/uv_spectroscopy.ipynb" rel="noopener">colab</a>.

## Results

### UV-Vis Absorption - UV-2550

<div class="tabs">
  <input type="radio" name="uv-tab" id="uv-overlay" checked>
  <input type="radio" name="uv-tab" id="uv-baseline">
  <input type="radio" name="uv-tab" id="uv-quinine">
  <input type="radio" name="uv-tab" id="uv-yellow">
  <input type="radio" name="uv-tab" id="uv-pink">
  <input type="radio" name="uv-tab" id="uv-salicylate">

  <div class="tab-labels">
    <label for="uv-overlay">Overlay</label>
    <label for="uv-baseline">Baseline</label>
    <label for="uv-quinine">Quinine</label>
    <label for="uv-yellow">Yellow HL</label>
    <label for="uv-pink">Pink HL</label>
    <label for="uv-salicylate">Salicylate</label>
  </div>

  <div class="tab-content" id="content-uv-overlay">
    <img src="output/images/uvvis_overlay.png" alt="UV-Vis overlay — four water samples" class="result-img">
    <p>Four fluorophores on one axis. <strong>Yellow HL</strong> is the only sample that landed in the 0.3–0.8 A sweet spot (A = 0.40 at 454 nm). Quinine, pink, and salicylate all over-diluted below A = 0.1 — the iterative protocol overshot three times out of four.</p>
  </div>
  <div class="tab-content" id="content-uv-baseline">
    <img src="output/images/uvvis_baseline.png" alt="Distilled water baseline" class="result-img">
    <p>Distilled water against a water baseline — flat near zero across 200–800 nm. Confirms clean background subtraction before samples loaded. Water's O–H overtones don't appear until the NIR (see Lambda 750 below).</p>
  </div>
  <div class="tab-content" id="content-uv-quinine">
    <img src="output/images/uvvis_quinine.png" alt="Quinine UV-Vis spectrum" class="result-img">
    <p><strong>Quinoline π→π* at 347 nm</strong> — the bicyclic nitrogen-heterocycle that makes tonic water glow under UV (see FluoroMax tab). A = 0.10 after 9 dilution iterations: over-diluted, below the 0.3–0.8 target.</p>
  </div>
  <div class="tab-content" id="content-uv-yellow">
    <img src="output/images/uvvis_yellow.png" alt="Yellow highlighter UV-Vis spectrum" class="result-img">
    <p><strong>Fluorescein-family dye — xanthene ring absorbs in the blue at 454 nm</strong>, ink appears yellow (the complement). A = 0.40 landed cleanly on the first try. Textbook fluorescein λ<sub>max</sub> is 488 nm; the 34 nm blue-shift here marks this as a fluorescein variant, not pure sodium fluorescein.</p>
  </div>
  <div class="tab-content" id="content-uv-pink">
    <img src="output/images/uvvis_pink.png" alt="Pink highlighter UV-Vis spectrum" class="result-img">
    <p><strong>Rhodamine-family dye — dialkyl-amino groups on the xanthene ring shift absorption to 532 nm</strong> (green), ink appears pink (the complement). A = 0.05: over-diluted at ⅙ drop, barely above noise. Rhodamines are the brighter, more photostable sibling to fluoresceins — the workhorse dye for single-molecule fluorescence.</p>
  </div>
  <div class="tab-content" id="content-uv-salicylate">
    <img src="output/images/uvvis_salicylate.png" alt="Salicylate UV-Vis spectrum" class="result-img">
    <p>Salicylate anion, freed from aspirin by NaHCO₃. <strong>Hydroxybenzoate π→π* at 307 nm</strong> — UV only, so aspirin solutions look colorless. A = 0.06 at ⅕ of ⅙ drop; the ⅙ alone saturated at A ≈ 5, the ⅕ dilution over-corrected.</p>
  </div>
</div>

### Fluorescence - FluoroMax-3

<div class="tabs">
  <input type="radio" name="flu-tab" id="flu-quinine" checked>
  <input type="radio" name="flu-tab" id="flu-yellow">
  <input type="radio" name="flu-tab" id="flu-pink">
  <input type="radio" name="flu-tab" id="flu-salicylate">

  <div class="tab-labels">
    <label for="flu-quinine">Quinine</label>
    <label for="flu-yellow">Yellow HL</label>
    <label for="flu-pink">Pink HL</label>
    <label for="flu-salicylate">Salicylate</label>
  </div>

  <div class="tab-content" id="content-flu-quinine">
    <img src="output/images/fluoromax_quinine.png" alt="Quinine excitation and emission spectra" class="result-img">
    <p>Textbook quinine fluorescence. λ<sub>ex</sub> = <strong>350 nm</strong> (matches UV-2550 and prediction), λ<sub>em</sub> = <strong>445 nm</strong>, Stokes shift <strong>95 nm</strong> — typical for a rigid quinoline framework. The blue glow you see when tonic water sits under a UV lamp.</p>
  </div>
  <div class="tab-content" id="content-flu-yellow">
    <img src="output/images/fluoromax_yellow.png" alt="Yellow highlighter excitation and emission spectra" class="result-img">
    <p>λ<sub>ex</sub> = <strong>403 nm</strong>, λ<sub>em</sub> = <strong>512 nm</strong>, Stokes shift <strong>109 nm</strong> — much larger than pure fluorescein's ~30 nm, confirming a perturbed xanthene variant. Spikes around 450–500 nm are Rayleigh scatter from the excitation beam bleeding into the detector.</p>
  </div>
  <div class="tab-content" id="content-flu-pink">
    <img src="output/images/fluoromax_pink.png" alt="Pink highlighter emission only" class="result-img">
    <p><strong>Emission only</strong> — excitation scan not collected (plan next session). λ<sub>em</sub> = <strong>582 nm</strong> near the 585 prediction; orange-red rhodamine glow. Broad tail toward longer wavelengths may indicate dimer formation — rhodamines self-quench above ~10 μM.</p>
  </div>
  <div class="tab-content" id="content-flu-salicylate">
    <img src="output/images/fluoromax_salicylate.png" alt="Salicylate excitation and emission spectra" class="result-img">
    <p><strong>ESIPT in action.</strong> λ<sub>ex</sub> = 301, λ<sub>em</sub> = 409 (both match predictions). Stokes shift <strong>108 nm</strong> — unusually large for a small aromatic. The fingerprint of excited-state intramolecular proton transfer: the excited state shuffles a proton from the ortho-OH to the carboxylate before emitting.</p>
  </div>
</div>

### Solvent NIR - Lambda 750

<img src="output/images/lambda750_water.png" alt="Lambda 750 distilled water NIR spectrum" class="result-img">

Brief exploratory scan of distilled water — one pass on the PerkinElmer Lambda 750 (200–2500 nm), kept for reference. Not revisited. The 10 mm cuvette saturated the detector across most of the NIR, but you can still pick out where water's **O–H overtone bands** sit: the clustered absorption spikes line up with the expected 970 nm (2nd overtone), 1200 nm (combination), and 1450 nm (1st overtone). Beyond ~1500 nm the detector is fully pinned.

<h2 id="extensions">Extensions</h2>

<div class="photo-grid">
  <img src="photos/setup/setup12.jpeg" alt="PerkinElmer Lambda 750 UV/Vis/NIR Spectrophotometer">
  <img src="photos/setup/setup18.jpeg" alt="Jasco J-1500 CD Spectrometer">
</div>

<div class="instrument-table no-highlight">

| Instrument | Extension | Description |
|------------|-----------|-------------|
| [PerkinElmer Lambda 750 UV/Vis/NIR Spectrophotometer](photos/setup/setup12.jpeg) 📷 | Range | More definition and extend into near-infrared (200–2500 nm) for solvent overtones |
| [Jasco J-1500 CD Spectrometer](photos/setup/setup18.jpeg) 📷 | Chirality | Detect chiral molecules and protein secondary structure |

</div>
