---
layout: project
project: Melting Point
photos:
  - photos/20260405 Setup A.jpeg
  - photos/20260405 Setup B.jpeg
  - photos/20260405 Setup C.jpeg
  - photos/20260405 Setup D.jpeg
  - photos/20260405 Setup E.jpeg
  - photos/20260405 Setup F.jpeg
  - photos/20260405 Setup G.jpeg
  - photos/20260405 Samples A.jpeg
  - photos/20260405 Samples B.jpeg
  - photos/20260405 Samples C.jpeg
---

<div class="page-header"><h2>Research</h2><div class="header-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div></div>

<div class="project-title"><h1>Melting Point of Everyday Compounds</h1><span class="chip chem">Chemistry</span></div>

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="Experiment photo">
  <img id="photo-1" alt="Experiment photo">
  <img id="photo-2" alt="Experiment photo">
  <img id="photo-3" alt="Experiment photo">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">Shuffle Photos</button>

<script>var _pagePhotos = {{ page.photos | jsonify }};</script>
<script src="/archives/layout/shuffle.js"></script>

<div class="section-heading"><h2>Overview</h2><span class="section-date">April 5th 2026</span></div>

Melting point determination is a fundamental technique for identifying and assessing the purity of solid compounds. A pure substance melts sharply at a characteristic temperature, while impurities broaden the melting range and depress the onset temperature. This experiment aimed to measure melting points of caffeine and aspirin using capillary tube method on an automated melting point apparatus with digital image processing.

**Status:** The OptiMelt instrument was non-functional during this session — the touchscreen was unresponsive and could not be used to configure or start a run. Samples were prepared but no measurements were collected. This project is on hold pending instrument repair or access to an alternative melting point apparatus.

## Setup

<div class="setup-highlight" markdown="1">

| Category | Details |
|----------|---------|
| Instrument | OptiMelt Automated Melting Point System |
| Method | Capillary tube, digital image processing |
| Capillary tubes | Eisco Labs Borosilicate Glass Capillary Melting Tubes, 4″ long, 0.05″ OD |
| Samples | Caffeine (CAF), aspirin (ASP) |
| Replicates | 3 capillary tubes per compound |

</div>

## Samples

<div class="hero-single"><img src="photos/20260405 Samples A.jpeg" alt="Capillary tubes labeled CAF1–3 and MP1–3"></div>

Samples were ground to a fine powder and packed into glass capillary tubes (~2–3 mm fill height). Each compound was prepared in triplicate (CAF 1–3, ASP 1–3) to allow averaging and assess reproducibility. Tubes were labeled and inserted into the OptiMelt sample chamber.

## Data

No data was collected — the instrument was non-functional. If the experiment is repeated, the OptiMelt outputs a temperature-vs-time curve with onset and clear points for each capillary.

## Results

Pending instrument repair. Expected deliverables when data is available:

- Melting onset and clear point for each replicate
- Mean melting point ± standard deviation per compound
- Comparison to literature values (caffeine: 235–237 °C, aspirin: 135–136 °C)
- Temperature-time curves from the OptiMelt software

This project connects to the broader thermal analysis series — the next step is thermogravimetric analysis (TGA) on the TA Instruments TGA Q50.

---

<div class="footer"><a class="footer-github" href="/">Science</a><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a class="active" href="/research/">Research</a></div></div>
