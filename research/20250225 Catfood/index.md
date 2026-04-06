---
layout: project
project: Cat Food Color Preference
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

# Red or Green, What Colored Cat Food does Mi Prefer?

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

<div class="project-meta">February 25th 2025</div>

## Overview

Does a cat prefer red or green colored food? This experiment tested whether a British Shorthair cat (Mi) shows a statistically significant preference for red- or green-dyed cat food. Regular dry cat food was dyed with food coloring and presented in two side-by-side bowls over 30 days. The bowl Mi approached first was recorded as his preference for that day. A chi-squared test was used to determine whether the observed preference differed significantly from chance.

## Setup

| Category | Details |
|----------|---------|
| Subject | British Shorthair cat (Mi) |
| Food | Regular dry cat food |
| Dye | Red and green food coloring |
| Serving | 10 pieces per bowl per trial |
| Duration | 30 days (August-September 2024) |

Colored cat food was prepared by mixing regular dry food with red and green food coloring in separate jars. Each day, two bowls were placed side by side — one with 10 red pieces and one with 10 green pieces. Bowl positions were alternated daily to control for side bias. The color Mi approached and began eating first was recorded as his preference. Remaining pieces, serving time, and food dye concentration were also tracked. Days where Mi did not eat from either bowl were excluded. After 30 days, a chi-squared goodness-of-fit test was applied to the observed preferences.

## Data

Raw data was recorded on handwritten data sheets and photographed. Variables tracked per trial include: date, serving number, pieces served and remaining, bowl position (left/right), serving time, and food dye drops used.

<div class="photo-grid three-col" id="data-grid">
  <img id="data-0" alt="Data sheet">
  <img id="data-1" alt="Data sheet">
  <img id="data-2" alt="Data sheet">
</div>

<script>
var allData = {{ page.data_photos | jsonify }};
(function() {
  for (var i = 0; i < allData.length; i++) {
    document.getElementById('data-' + i).src = allData[i];
  }
})();
</script>

## Results

Over 30 days, Mi chose red on 13 days and green on 17 days. A chi-squared goodness-of-fit test with one degree of freedom yielded a test statistic of 0.533, well below the critical value of 3.841 at 95% confidence. The null hypothesis (no color preference) was not rejected. Mi shows no statistically significant preference for red or green cat food.

**Note — correction to written report:** Claude identified an arithmetic error in the original PDF report. The report calculates χ² = 0.266 by dividing each (O − E)² term by 30 (the total number of observations). The correct chi-squared formula divides each term by the expected count for that category (15), not the total N. The corrected value is χ² = (13 − 15)² / 15 + (17 − 15)² / 15 = 0.267 + 0.267 = **0.533**, as computed in the reproducible notebook. The conclusion is unchanged — both values fall well below the critical value of 3.841 — but 0.533 is the correct test statistic.

See the <a href="https://github.com/vivianweidai/science/blob/main/research/20250225%20Catfood/OUTPUT/20250225%20Catfood.pdf">written report</a>, the <a href="https://github.com/vivianweidai/science/blob/main/research/20250225%20Catfood/OUTPUT/catfood_analysis.ipynb">static notebook</a> or <a href="https://colab.research.google.com/github/vivianweidai/science/blob/main/research/20250225%20Catfood/OUTPUT/catfood_analysis.ipynb">run the reproducible analysis yourself</a>.

---

<div class="footer"><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/science/tree/main/research/20250225%20Catfood">View on GitHub</a></div>
