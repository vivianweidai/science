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

### Representatives

<style>
#tab-acetone:checked ~ .tab-labels label[for="tab-acetone"],
#tab-water:checked ~ .tab-labels label[for="tab-water"],
#tab-salt:checked ~ .tab-labels label[for="tab-salt"],
#tab-plastic:checked ~ .tab-labels label[for="tab-plastic"],
#tab-sugar:checked ~ .tab-labels label[for="tab-sugar"] {
  color: #0969da;
  border-bottom-color: #0969da;
}
#tab-acetone:checked ~ #content-acetone,
#tab-water:checked ~ #content-water,
#tab-salt:checked ~ #content-salt,
#tab-plastic:checked ~ #content-plastic,
#tab-sugar:checked ~ #content-sugar {
  display: block;
}
</style>

<div class="tabs">
  <input type="radio" name="spec-tab" id="tab-acetone">
  <input type="radio" name="spec-tab" id="tab-water">
  <input type="radio" name="spec-tab" id="tab-salt">
  <input type="radio" name="spec-tab" id="tab-plastic">
  <input type="radio" name="spec-tab" id="tab-sugar">

  <div class="tab-labels">
    <label for="tab-acetone">Acetone</label>
    <label for="tab-water">Water</label>
    <label for="tab-salt">Salt</label>
    <label for="tab-plastic">Plastic Bag</label>
    <label for="tab-sugar">Sugar</label>
  </div>

  <div class="tab-content" id="content-acetone">
    <img src="OUTPUT/acetone_spectrum.png" alt="Acetone spectrum" style="width:100%; border-radius:6px;">
    <p>Acetone shows a textbook IR spectrum. The dominant peak at ~1,715 cm⁻¹ is the C=O carbonyl stretch — the strongest and most characteristic absorption in ketones. The C–H methyl stretches appear around 2,950–3,000 cm⁻¹, the peaks at ~1,350–1,450 cm⁻¹ are C–H bending (symmetric and asymmetric scissoring of the CH₃ groups), and the sharp peaks in the 1,000–1,300 cm⁻¹ region correspond to C–O and C–C skeletal stretches. The absence of a broad O–H band confirms the sample is anhydrous.</p>
  </div>

  <div class="tab-content" id="content-water">
    <img src="OUTPUT/water_spectrum.png" alt="Water spectrum" style="width:100%; border-radius:6px;">
    <p>Water produces the classic broad O–H stretching band centered around 3,300 cm⁻¹, spanning nearly the entire 3,000–3,600 cm⁻¹ region due to hydrogen bonding. The sharp peak at ~1,640 cm⁻¹ is the O–H bending (scissoring) mode. The strong absorption rising below 1,000 cm⁻¹ is the librational (rocking) mode of liquid water.</p>
  </div>

  <div class="tab-content" id="content-salt">
    <img src="OUTPUT/salt_spectrum.png" alt="Salt spectrum" style="width:100%; border-radius:6px;">
    <p>Salt (NaCl) is an ionic compound with no covalent bonds, so it produces a nearly flat baseline with no characteristic IR absorptions. The small features visible are likely surface moisture (trace O–H) and atmospheric CO₂ interference. This makes salt an effective negative control and explains why NaCl is traditionally used for IR sample windows.</p>
  </div>

  <div class="tab-content" id="content-plastic">
    <img src="OUTPUT/plastic_bag_spectrum.png" alt="Plastic Bag spectrum" style="width:100%; border-radius:6px;">
    <p>Polyethylene (plastic bag) shows an almost pure C–H spectrum. The sharp doublet at ~2,920 and ~2,850 cm⁻¹ corresponds to asymmetric and symmetric C–H stretching of the CH₂ backbone. The C–H bending peaks at ~1,460 cm⁻¹ (scissoring) and ~720 cm⁻¹ (rocking) complete the picture. No O–H, C=O, or other heteroatom peaks — just carbon and hydrogen.</p>
  </div>

  <div class="tab-content" id="content-sugar">
    <img src="OUTPUT/sugar_spectrum.png" alt="Sugar spectrum" style="width:100%; border-radius:6px;">
    <p>Sugar (sucrose) shows a broad O–H stretching band at 3,000–3,500 cm⁻¹ from its many hydroxyl groups, plus a rich fingerprint region below 1,500 cm⁻¹ dominated by C–O stretching vibrations of the glycosidic bond and sugar ring. The complexity of the fingerprint region reflects the molecule's size — each sugar has a unique IR fingerprint that can be used for identification.</p>
  </div>
</div>

<script>
(function() {
  var tabs = ['acetone','water','salt','plastic','sugar'];
  var pick = tabs[Math.floor(Math.random() * tabs.length)];
  document.getElementById('tab-' + pick).checked = true;
})();
</script>

See the <a href="https://github.com/vivianweidai/research/blob/main/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">static notebook</a> or <a href="https://colab.research.google.com/github/vivianweidai/research/blob/main/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">run the reproducible analysis yourself</a>.

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy">View on GitHub</a></div>
