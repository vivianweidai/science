---
layout: project
project: Melting Point
photos:
  - PHOTOS/20260405 Setup A.jpeg
  - PHOTOS/20260405 Setup B.jpeg
  - PHOTOS/20260405 Setup C.jpeg
  - PHOTOS/20260405 Setup D.jpeg
  - PHOTOS/20260405 Setup E.jpeg
  - PHOTOS/20260405 Setup F.jpeg
  - PHOTOS/20260405 Setup G.jpeg
  - PHOTOS/20260405 Samples A.jpeg
  - PHOTOS/20260405 Samples B.jpeg
  - PHOTOS/20260405 Samples C.jpeg
---

# Melting Point of Everyday Compounds

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

<div class="project-meta">April 5th 2026<br>SRS OptiMelt Automated Melting Point System</div>

## Overview

Melting point determination is a fundamental technique for identifying and assessing the purity of solid compounds. A pure substance melts sharply at a characteristic temperature, while impurities broaden the melting range and depress the onset temperature. This experiment aimed to measure melting points of caffeine and aspirin using capillary tube method on an automated melting point apparatus with digital image processing.

**Status:** The OptiMelt instrument was non-functional during this session — the touchscreen was unresponsive and could not be used to configure or start a run. Samples were prepared but no measurements were collected. This project is on hold pending instrument repair or access to an alternative melting point apparatus.

## Setup

| Category | Details |
|----------|---------|
| Instrument | SRS OptiMelt Automated Melting Point System |
| Method | Capillary tube, digital image processing |
| Capillary tubes | Eisco Labs Borosilicate Glass Capillary Melting Tubes, 4″ long, 0.05″ OD (100-pack) |
| Samples | Caffeine (CAF), aspirin (ASP) |
| Replicates | 3 capillary tubes per compound |

## Samples

<div class="hero-single"><img src="PHOTOS/20260405 Samples A.jpeg" alt="Capillary tubes labeled CAF1–3 and MP1–3"></div>

Samples were ground to a fine powder and packed into glass capillary tubes (~2–3 mm fill height). Each compound was prepared in triplicate (CAF 1–3, ASP 1–3) to allow averaging and assess reproducibility. Tubes were labeled and inserted into the OptiMelt sample chamber.

## Data

No data was collected — the instrument was non-functional. If the experiment is repeated, the OptiMelt outputs a temperature-vs-time curve with onset and clear points for each capillary.

## Results

Pending instrument repair. Expected deliverables when data is available:

- Melting onset and clear point for each replicate
- Mean melting point ± standard deviation per compound
- Comparison to literature values (caffeine: 235–237 °C, aspirin: 135–136 °C)
- Temperature-time curves from the OptiMelt software

This project connects to the broader thermal analysis series — the next step is thermogravimetric analysis (TGA) on the TA Instruments Q50.

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/20260405%20Melting%20Point">View on GitHub</a></div>
