---
layout: project
project: Cat Food Colour Preference
photos:
  - PHOTOS/20240901 Catfood A.jpeg
  - PHOTOS/20240901 Catfood B.jpeg
  - PHOTOS/20240901 Catfood C.jpeg
  - PHOTOS/20240901 Catfood D.jpeg
  - PHOTOS/20240906 Catfood.jpeg
  - PHOTOS/20240907 Catfood A.jpeg
  - PHOTOS/20240907 Catfood B.jpeg
  - PHOTOS/20240920 Catfood A.jpeg
  - PHOTOS/20240920 Catfood B.jpeg
  - PHOTOS/20240920 Catfood C.jpeg
  - PHOTOS/20240920 Catfood D.jpeg
  - PHOTOS/20240920 Catfood E.jpeg
  - PHOTOS/20240920 Catfood F.jpeg
  - PHOTOS/20240920 Catfood G.jpeg
  - PHOTOS/20240920 Catfood H.jpeg
  - PHOTOS/20240920 Catfood I.jpeg
  - PHOTOS/20240920 Catfood J.jpeg
  - PHOTOS/20240920 Catfood K.jpeg
  - PHOTOS/20240920 Catfood L.jpeg
  - PHOTOS/20240920 Catfood M.jpeg
  - PHOTOS/20240923 Catfood A.jpeg
  - PHOTOS/20240923 Catfood B.jpeg
data_photos:
  - DATA/20240901 Catfood B.jpeg
  - DATA/20240907 Catfood B.jpeg
  - DATA/20240920 Catfood N.jpeg
---

# Red or Green, What Coloured Cat Food does Mi Prefer?

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

<div class="project-meta">February 25th 2025</div>

## Overview

Does a cat prefer red or green coloured food? This experiment tested whether a British Shorthair cat (Mi) shows a statistically significant preference for red- or green-dyed cat food. Regular dry cat food was dyed with food colouring and presented in two side-by-side bowls over 30 days. The bowl Mi approached first was recorded as his preference for that day. A chi-squared test was used to determine whether the observed preference differed significantly from chance.

## Materials

| # | Category | Details |
|---|----------|---------|
| 1 | Subject | British Shorthair cat (Mi) |
| 2 | Food | Regular dry cat food (Kirkland) |
| 3 | Dye | Red and green food colouring |
| 4 | Serving | 10 pieces per bowl per trial |
| 5 | Duration | 30 days (August-September 2024) |

## Data

Raw data is recorded on handwritten data sheets, photographed as JPEG images. Variables tracked per trial include: date, serving number, number of red/green pieces served, pieces remaining, bowl position (left/right), serving time, and number of food dye drops used. View the raw data sheets on <a href="https://github.com/vivianweidai/research/tree/main/20250225%20Catfood/DATA">GitHub</a>.

<div class="photo-grid three-col" id="data-grid">
  <img id="data-0" alt="Data sheet">
  <img id="data-1" alt="Data sheet">
  <img id="data-2" alt="Data sheet">
</div>
<button class="shuffle-btn" onclick="shuffleData()">Shuffle Data</button>

<script>
var allData = {{ page.data_photos | jsonify }};
function shuffleData() {
  var shuffled = allData.slice().sort(function() { return 0.5 - Math.random(); });
  for (var i = 0; i < Math.min(shuffled.length, 3); i++) {
    document.getElementById('data-' + i).src = shuffled[i];
  }
}
shuffleData();
</script>

## Methods

1. Prepared coloured cat food by mixing regular dry food with red and green food colouring in separate jars
2. Each trial: placed two bowls side by side, one with 10 red pieces and one with 10 green pieces
3. Alternated bowl positions (left/right) between trials to control for side bias
4. Recorded which colour Mi approached and began eating first
5. Tracked remaining pieces, serving time, and food dye concentration
6. Days where Mi did not eat from either bowl were excluded
7. After 30 days, applied a chi-squared test to the observed preferences

## Results

Over 30 days, Mi chose red on 13 days and green on 17 days. A chi-squared goodness-of-fit test with one degree of freedom yielded a test statistic of 0.533, well below the critical value of 3.841 at 95% confidence. The null hypothesis (no colour preference) was not rejected. Mi shows no statistically significant preference for red or green cat food.

See the <a href="https://github.com/vivianweidai/research/blob/main/20250225%20Catfood/OUTPUT/20250225%20Catfood.pdf">written report</a> (PDF) or the <a href="https://github.com/vivianweidai/research/blob/main/20250225%20Catfood/OUTPUT/catfood_analysis.ipynb">full reproducible analysis</a> (Jupyter notebook).

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/20250225%20Catfood">View on GitHub</a></div>
