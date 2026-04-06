---
layout: project
project: Four-Point Probe
photos:
  - PHOTOS/20260404 Samples A.jpeg
  - PHOTOS/20260404 Samples B.jpeg
  - PHOTOS/20260404 Samples C.jpeg
  - PHOTOS/20260404 Setup 1.jpeg
  - PHOTOS/20260404 Setup 2.jpeg
  - PHOTOS/20260404 Setup 3.jpeg
  - PHOTOS/20260404 Setup 4.jpeg
  - PHOTOS/20260404 Setup 5.jpeg
  - PHOTOS/20260404 Setup 6.jpeg
  - PHOTOS/20260404 Setup 7.jpeg
  - PHOTOS/20260404 Setup 8.jpeg
  - PHOTOS/20260404 Setup 9.jpeg
  - PHOTOS/20260404 Setup 10.jpeg
  - PHOTOS/20260404 Setup 11.jpeg
  - PHOTOS/20260404 Setup 12.jpeg
  - PHOTOS/20260404 Setup 13.jpeg
  - PHOTOS/20260404 Setup 14.jpeg
  - PHOTOS/20260404 Setup 15.jpeg
  - PHOTOS/20260404 Setup 16.jpeg
  - PHOTOS/20260404 Setup 17.jpeg
  - PHOTOS/20260404 Setup 18.jpeg
  - PHOTOS/20260404 Setup 19.jpeg
  - PHOTOS/20260404 Setup 20.jpeg
  - PHOTOS/20260404 Setup 21.jpeg
  - PHOTOS/20260404 Setup 22.jpeg
  - PHOTOS/20260404 Setup 23.jpeg
  - PHOTOS/20260404 Setup 24.jpeg
  - PHOTOS/20260404 Setup 25.jpeg
  - PHOTOS/20260404 Setup 26.jpeg
  - PHOTOS/20260404 Setup 27.jpeg
  - PHOTOS/20260404 Setup 28.jpeg
  - PHOTOS/20260404 Setup 29.jpeg
  - PHOTOS/20260404 Setup 30.jpeg
  - PHOTOS/20260404 Setup 31.jpeg
  - PHOTOS/20260404 Setup 32.jpeg
  - PHOTOS/20260404 Setup 33.jpeg
  - PHOTOS/20260404 Setup 34.jpeg
  - PHOTOS/20260404 Setup 35.jpeg
  - PHOTOS/20260404 Setup 36.jpeg
  - PHOTOS/20260404 Setup 37.jpeg
  - PHOTOS/20260404 Setup 38.jpeg
  - PHOTOS/20260404 Setup 39.jpeg
  - PHOTOS/20260404 Setup 40.jpeg
  - PHOTOS/20260404 Setup 41.jpeg
  - PHOTOS/20260404 Setup 42.jpeg
  - PHOTOS/20260404 Setup 43.jpeg
  - PHOTOS/20260404 Setup 44.jpeg
  - PHOTOS/20260404 Setup 45.jpeg
  - PHOTOS/20260404 Setup 46.jpeg
  - PHOTOS/20260404 Setup 47.jpeg
  - PHOTOS/20260404 Setup 48.jpeg
  - PHOTOS/20260404 Setup 49.jpeg
  - PHOTOS/20260404 Setup 50.jpeg
  - PHOTOS/20260404 Setup 51.jpeg
  - PHOTOS/20260404 Setup 52.jpeg
  - PHOTOS/20260404 Setup 53.jpeg
  - PHOTOS/20260404 Setup 54.jpeg
  - PHOTOS/20260404 Setup 55.jpeg
  - PHOTOS/20260404 Setup 56.jpeg
  - PHOTOS/20260404 Setup 57.jpeg
  - PHOTOS/20260404 Setup 58.jpeg
  - PHOTOS/20260404 Setup 59.jpeg
  - PHOTOS/20260404 Setup 60.jpeg
  - PHOTOS/20260404 Setup 61.jpeg
  - PHOTOS/20260404 Setup 62.jpeg
  - PHOTOS/20260404 Setup 63.jpeg
  - PHOTOS/20260404 Setup 64.jpeg
  - PHOTOS/20260404 Setup 65.jpeg
  - PHOTOS/20260404 Setup 66.jpeg
  - PHOTOS/20260404 Setup 67.jpeg
  - PHOTOS/20260404 Setup 68.jpeg
  - PHOTOS/20260404 Setup 69.jpeg
  - PHOTOS/20260404 Setup 70.jpeg
  - PHOTOS/20260404 Setup 71.jpeg
  - PHOTOS/20260404 Setup 72.jpeg
  - PHOTOS/20260404 Setup 73.jpeg
  - PHOTOS/20260404 Setup 74.jpeg
  - PHOTOS/20260404 Setup 75.jpeg
  - PHOTOS/20260404 Setup 76.jpeg
  - PHOTOS/20260404 Setup 77.jpeg
  - PHOTOS/20260404 Setup 78.jpeg
  - PHOTOS/20260404 Setup 79.jpeg
  - PHOTOS/20260404 Setup 80.jpeg
  - PHOTOS/20260404 Setup 81.jpeg
  - PHOTOS/20260404 Setup 82.jpeg
  - PHOTOS/20260404 Setup 83.jpeg
  - PHOTOS/20260404 Setup 84.jpeg
  - PHOTOS/20260404 Setup 85.jpeg
  - PHOTOS/20260404 Setup 86.jpeg
  - PHOTOS/20260404 Setup 87.jpeg
  - PHOTOS/20260404 Setup 88.jpeg
  - PHOTOS/20260404 Setup 89.jpeg
  - PHOTOS/20260404 Setup 90.jpeg
  - PHOTOS/20260404 Setup 91.jpeg
  - PHOTOS/20260404 Setup 92.jpeg
  - PHOTOS/20260404 Setup 93.jpeg
  - PHOTOS/20260404 Setup 94.jpeg
  - PHOTOS/20260404 Setup 95.jpeg
  - PHOTOS/20260404 Setup 96.jpeg
  - PHOTOS/20260404 Setup 97.jpeg
  - PHOTOS/20260404 Setup 98.jpeg
  - PHOTOS/20260404 Setup 99.jpeg
  - PHOTOS/20260404 Setup 100.jpeg
  - PHOTOS/20260404 Setup 101.jpeg
  - PHOTOS/20260404 Setup 102.jpeg
---

# Four-Point Probe Resistivity Measurements

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

<div class="project-meta">April 4th 2026<br>Jandel RM3-AR Four-Point Probe Test Unit</div>

## Overview

Sheet resistance and resistivity measurements of conductive materials using the four-point probe technique. The Jandel RM3 applies a known current through the outer two probes and measures the voltage drop across the inner two, eliminating contact resistance from the measurement.

## Setup

| Category | Details |
|----------|---------|
| Instrument | Jandel RM3-AR Four-Point Probe Test Unit |
| Technique | Four-point probe (Kelvin sensing) |
| Measurement | Sheet resistance (Ω/□) and resistivity (Ω·cm) |
| Correction | Geometric correction factors applied to V/I ratio |

A background measurement was taken first to verify probe contact. Each sample was placed on the measurement stage, the four-point probe head lowered onto the surface, and current applied through the outer probes while voltage was measured across the inner two. Sheet resistance was calculated from the V/I ratio with geometric correction factors. Multiple points were measured per sample.

### Samples

<div class="hero-single"><img src="PHOTOS/20260404 Samples B.jpeg" alt="Samples"></div>

## Data

Raw measurement data available on <a href="https://github.com/vivianweidai/research/tree/main/20260404%20Four%20Point%20Probe/DATA">GitHub</a>.

## Results

*Analysis in progress.*

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/20260404%20Four%20Point%20Probe">View on GitHub</a></div>
