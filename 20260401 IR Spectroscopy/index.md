---
layout: project
project: IR Spectroscopy
photos:
  - PHOTOS/20260404 Setup A.jpeg
  - PHOTOS/20260404 Setup B.jpeg
  - PHOTOS/20260404 Setup C.jpeg
  - PHOTOS/20260404 Setup D.jpeg
  - PHOTOS/20260404 Setup E.jpeg
  - PHOTOS/20260404 Setup F.jpeg
  - PHOTOS/20260404 Samples A.jpeg
  - PHOTOS/20260404 Samples B.jpeg
---

# IR Spectroscopy of Everyday Materials

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

<div class="project-meta">April 1st 2026<br>Thermo Scientific Nicolet iS5 FT-IR Spectrometer (ATR mode)</div>

## Overview

Fourier-transform infrared (FT-IR) spectroscopy identifies the polar covalent bonds in a material by measuring which infrared frequencies it absorbs. Different functional groups — O-H, C=O, C-H, N-H, and others — vibrate at characteristic frequencies, producing a unique absorption fingerprint for each compound. This survey of common household and laboratory materials uses the FT-IR spectrometer in ATR mode to capture each sample's spectrum across the mid-infrared range (~550–4000 cm⁻¹), building a reference library of spectra and identifying characteristic functional group signatures in everyday substances.

## Setup

| Category | Details |
|----------|---------|
| Instrument | Thermo Scientific Nicolet iS5 FT-IR Spectrometer |
| Mode | Attenuated Total Reflectance (ATR) |
| Range | ~550–4000 cm⁻¹ |
| Resolution | ~7,150 data points per spectrum |
| Runs | Two sessions (19 + 6 samples) |

A background spectrum was collected first to establish a baseline. Each sample was placed directly on the ATR crystal, a spectrum acquired across the mid-IR range, and the raw CSV exported from the instrument software.

### Samples

<div class="hero-single"><img src="PHOTOS/20260404 Samples B.jpeg" alt="Samples"></div>

| # | Category | Samples |
|---|----------|---------|
| 1 | Solvents | acetone, isopropanol, water |
| 2 | Food/minerals | coffee, salt, sugar |
| 3 | Personal care | soap, shampoo, conditioner, lotion, sunscreen, cleaner |
| 4 | Polymers | plastic bag, plastic cap, plastic glove, plastic wrapper |
| 5 | Paper | paper, paper-plastic cup |
| 6 | Biological | finger, leaf, orange peel |
| 7 | Control | background |

## Data

Raw spectra are available as CSV files each containing two columns (wavenumber in cm⁻¹ and transmittance in %) with ~7,150 data points per spectrum. Data is organized into two experimental runs: <a href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy/DATA/ONE">ONE</a> (19 samples) and <a href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy/DATA/TWO">TWO</a> (6 samples) over two different days.

## Methods

The instrument (Nicolet iS5) applies background correction automatically — each sample's transmittance is already measured relative to the background spectrum, so non-absorbing regions read ~100% transmittance. The data cleaning pipeline:

1. **Parse** — raw CSVs use scientific notation with no headers; each file was parsed into numeric wavenumber and transmittance columns.
2. **Convert to absorbance** — transmittance was converted using A = −log₁₀(T/100), where T is transmittance in percent. Absorbance is dimensionless and directly proportional to concentration via the Beer-Lambert law.
3. **Export** — all 23 samples were saved as individual cleaned CSVs with headers (wavenumber, transmittance, absorbance) into a single <a href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy/OUTPUT/SCRUBBED">SCRUBBED</a> folder.

## Results

<img src="OUTPUT/acetone_spectrum.png" alt="FT-IR Spectrum — Acetone" style="width:100%; border-radius:6px;">

Acetone shows a textbook IR spectrum. The dominant peak at ~1,715 cm⁻¹ is the C=O carbonyl stretch — the strongest and most characteristic absorption in ketones. The C–H methyl stretches appear around 2,950–3,000 cm⁻¹, and the sharp peaks in the 1,000–1,300 cm⁻¹ region correspond to C–O and C–C skeletal stretches. The absence of a broad O–H band confirms the sample is anhydrous.

See the <a href="https://github.com/vivianweidai/research/blob/main/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">static notebook</a> or <a href="https://colab.research.google.com/github/vivianweidai/research/blob/main/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">run the reproducible analysis yourself</a>.

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy">View on GitHub</a></div>
