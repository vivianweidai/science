---
layout: project
project: Cat Food Colour Preference
---

# Red or Green: Cat Food Colour Preference Experiment

<img src="PHOTOS/20240906 Catfood.jpeg" alt="Cat food colour preference experiment" width="100%">

**Date:** February 25th 2025

## Overview

Does a cat prefer red or green coloured food? This experiment tested whether a British Shorthair cat (Mi) shows a statistically significant preference for red- or green-dyed cat food. Regular dry cat food was dyed with food colouring and presented in two side-by-side bowls over 30 days. The bowl Mi approached first was recorded as his preference for that day. A chi-squared test was used to determine whether the observed preference differed significantly from chance.

## Samples

| # | Category | Details |
|---|----------|---------|
| 1 | Subject | British Shorthair cat (Mi) |
| 2 | Food | Regular dry cat food (Kirkland) |
| 3 | Dye | Red and green food colouring |
| 4 | Serving | 10 pieces per bowl per trial |
| 5 | Duration | 30 days (August-September 2024) |

## Data

Raw data is recorded on handwritten data sheets in `DATA/`, photographed as JPEG images. Variables tracked per trial include: date, serving number, number of red/green pieces served, pieces remaining, bowl position (left/right), serving time, and number of food dye drops used.

## Results

Over 30 days, Mi chose red on 13 days and green on 17 days. A chi-squared goodness-of-fit test with one degree of freedom yielded a test statistic of 0.266, well below the critical value of 3.841 at 95% confidence. The null hypothesis (no colour preference) was not rejected. Mi shows no statistically significant preference for red or green cat food.

See `OUTPUT/20250225 Catfood.pdf` for the full written report.

## Methods

1. Prepared coloured cat food by mixing regular dry food with red and green food colouring in separate jars
2. Each trial: placed two bowls side by side, one with 10 red pieces and one with 10 green pieces
3. Alternated bowl positions (left/right) between trials to control for side bias
4. Recorded which colour Mi approached and began eating first
5. Tracked remaining pieces, serving time, and food dye concentration
6. Days where Mi did not eat from either bowl were excluded
7. After 30 days, applied a chi-squared test to the observed preferences

---

<div class="footer"><div class="footer-nav"><a href="https://vivianweidai.com/curriculum/">Curriculum</a><a href="https://vivianweidai.com/olympiads/">Olympiads</a><a href="https://vivianweidai.com/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/research/tree/main/20250225%20Catfood">View on GitHub</a></div>
