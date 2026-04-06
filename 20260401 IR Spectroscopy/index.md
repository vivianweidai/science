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
  var shuffled = allPhotos.slice().sort(function() { return 0.5 - Math.random(); });
  for (var i = 0; i < 4; i++) {
    document.getElementById('photo-' + i).src = shuffled[i];
  }
}
shufflePhotos();
</script>

<div class="project-meta">April 1st 2026<br>Thermo Scientific Nicolet iS5 FT-IR Spectrometer (ATR mode)</div>

## Overview

Infrared spectroscopy survey of common household and laboratory materials. Each sample was measured using the FT-IR spectrometer to capture its absorption/transmittance spectrum across the mid-infrared range (~550–4000 cm⁻¹). The goal is to build a reference library of spectra and identify characteristic functional group signatures in everyday substances.

## Setup

| Category | Details |
|----------|---------|
| Instrument | Thermo Scientific Nicolet iS5 FT-IR Spectrometer |
| Mode | Attenuated Total Reflectance (ATR) |
| Range | ~550–4000 cm⁻¹ |
| Resolution | ~7,150 data points per spectrum |
| Runs | Two sessions (19 + 6 samples) |

A background spectrum was collected first to establish a baseline. Each sample was placed directly on the ATR crystal, a spectrum acquired across the mid-IR range, and the raw CSV exported from the instrument software. Bowl positions and sample order were varied between sessions.

### Samples

| # | Category | Samples |
|---|----------|---------|
| 1 | Solvents | acetone, isopropanol, water |
| 2 | Food/minerals | coffee, salt, sugar |
| 3 | Personal care | soap, shampoo, conditioner, lotion, sunscreen |
| 4 | Household | cleaner |
| 5 | Polymers | plastic bag, plastic cap, plastic glove, plastic wrapper, paper, paper-plastic cup |
| 6 | Biological | finger, leaf, orange peel |
| 7 | Control | background |

## Data

Raw spectra are available as CSV files on <a href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy/DATA">GitHub</a>. Each CSV contains two columns (wavenumber in cm⁻¹ and transmittance in %) with ~7,150 data points per spectrum. Data is organized into two experimental runs: <a href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy/DATA/ONE">ONE</a> (19 samples) and <a href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy/DATA/TWO">TWO</a> (6 samples).

## Results

*Analysis in progress.*

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/20260401%20IR%20Spectroscopy">View on GitHub</a></div>
