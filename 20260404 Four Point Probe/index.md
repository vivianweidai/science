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

Sheet resistance is a measure of how easily electric current flows across a thin material's surface, reported in ohms per square (Ω/□). It is widely used in semiconductor fabrication and materials science to characterize conductive coatings, thin films, and bulk materials without needing to know the exact thickness — making it practical for quick quality checks on anything from silicon wafers to household metals.

The four-point probe technique separates the current-carrying and voltage-sensing functions into different probe pairs. The Jandel RM3 applies a known current through the outer two probes and measures the voltage drop across the inner two. Because virtually no current flows through the voltage-sensing probes, the contact resistance between each probe tip and the sample surface drops out of the measurement entirely — only the resistance of the sample itself is captured. This is the same principle behind Kelvin (four-terminal) sensing used in precision resistance metrology.

## Setup

| Category | Details |
|----------|---------|
| Instrument | Jandel RM3-AR Four-Point Probe Test Unit |
| Technique | Four-point probe (Kelvin sensing) — separate current and voltage pairs eliminate contact resistance |
| Measurement | Sheet resistance (Ω/□) and resistivity (Ω·cm) |
| Correction | Geometric correction factor (π/ln2 ≈ 4.532) applied to V/I ratio for semi-infinite thin samples |

Each sample was placed on the measurement stage, the four-point probe head lowered onto the surface, and current applied through the outer probes while voltage was measured across the inner two. The instrument computes sheet resistance as R□ = (π/ln2) × (V/I), where the factor π/ln2 ≈ 4.532 is a geometric correction that accounts for the linear arrangement of four equally spaced probes on a large, thin sample. Multiple points were measured per sample.

### Samples

<div class="hero-single"><img src="PHOTOS/20260404 Setup 39.jpeg" alt="Tri-band penny under four-point probe"></div>

| Category | Samples |
|----------|---------|
| Coins | quarter, penny (unpolished / semi-polished / fully polished) |
| Household metals | stainless steel spoon, aluminum foil, metal washer, house key |
| Biological | leaf |
| Other | DVD, paper cardboard |

Conductive samples (coins, household metals) produced measurable sheet resistance readings. Non-conductive samples (leaf, DVD, paper cardboard) returned Contact Limit or Out of Range at all current settings. The penny was sanded into three bands — untouched copper, lightly polished, and fully sanded to exposed zinc — to compare surface condition effects. Each sample was measured multiple times in both forward and reverse current directions.

## Data

Raw data were photographs of the instrument display taken after each measurement. These were manually transcribed into a CSV file. The raw photos are in the <a href="https://github.com/vivianweidai/research/tree/main/20260404%20Four%20Point%20Probe/DATA">DATA</a> directory and the CSV is in the <a href="https://github.com/vivianweidai/research/tree/main/20260404%20Four%20Point%20Probe/OUTPUT">OUTPUT</a> directory.

## Results

Of the 67 measurement attempts, 56 produced valid sheet resistance readings at 9 µA. Three non-conductive samples (leaf, DVD, paper cardboard) returned Contact Limit at all current settings, and one metal washer reading was excluded due to an incorrect current range (20 mA).

| Sample | Material | n | Mean (Ω/□) | ± Std | Range |
|--------|----------|--:|------------|-------|-------|
| Quarter | Nickel-clad copper | 2 | 37.8 | 0.2 | 37.6–37.9 |
| Spoon | Stainless steel | 7 | 39.0 | 1.8 | 36.6–41.5 |
| Penny (unpolished) | Copper-plated zinc | 3 | 47.3 | 2.4 | 44.5–48.9 |
| Aluminum foil | Aluminum | 5 | 48.1 | 0.4 | 47.6–48.7 |
| Penny (semi-polished) | Copper-plated zinc | 10 | 48.6 | 1.6 | 46.1–51.8 |
| Penny (fully polished) | Copper-plated zinc | 16 | 50.1 | 2.5 | 47.5–55.7 |
| Aluminum foil (flipped) | Aluminum | 3 | 54.7 | 1.8 | 52.8–56.2 |
| Metal washer | Steel | 5 | 54.8 | 1.2 | 53.2–56.2 |
| House key | Brass | 5 | 57.2 | 1.0 | 56.1–58.3 |

<img src="OUTPUT/IMAGES/mean_sheet_resistance.png" alt="Mean sheet resistance by sample" style="width:100%; border-radius:6px;">

### Key Findings

**Conductivity ranking.** The quarter (nickel-clad copper) and stainless steel spoon were the most conductive samples, with the lowest sheet resistance. The brass house key was the least conductive metal tested. All non-metals were too resistive to measure.

**Penny surface condition.** Sanding the penny from unpolished copper through to fully exposed zinc *increased* sheet resistance — the unpolished copper surface (47.3 Ω/□) was more conductive than the fully polished zinc (50.1 Ω/□). This is consistent with copper being a better conductor than zinc.

<img src="OUTPUT/IMAGES/penny_surface_direction.png" alt="Penny surface condition analysis" style="width:100%; border-radius:6px;">

**Current direction.** Forward current consistently produced higher readings than reverse across all samples tested in both directions. The mean FWD–REV offset was several Ω/□, likely due to thermoelectric (Seebeck) effects at the probe-sample contacts or slight asymmetry in probe pressure.

**Aluminum foil orientation.** Flipping the foil upside down increased sheet resistance from 48.1 to 54.7 Ω/□ — the matte and shiny sides of aluminum foil have measurably different surface conductivity, possibly due to differences in oxide layer thickness or surface roughness from the rolling process.

See the <a href="https://github.com/vivianweidai/research/blob/main/20260404%20Four%20Point%20Probe/OUTPUT/four_point_probe_analysis.ipynb">static notebook</a> or <a href="https://colab.research.google.com/github/vivianweidai/research/blob/main/20260404%20Four%20Point%20Probe/OUTPUT/four_point_probe_analysis.ipynb">run the reproducible analysis yourself</a>.

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/20260404%20Four%20Point%20Probe">View on GitHub</a></div>
