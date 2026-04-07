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

<script>var _pagePhotos = {{ page.photos | jsonify }};</script>
<script src="/archives/formatting/shuffle.js"></script>

<div class="project-meta">April 1st 2026<br>Thermo Scientific Nicolet 380 FT-IR Spectrometer (ATR mode)</div>

## Overview

Fourier-transform infrared (FT-IR) spectroscopy identifies the polar covalent bonds in a material by measuring which infrared frequencies it absorbs. Different functional groups — O-H, C=O, C-H, N-H, and others — vibrate at characteristic frequencies, producing a unique absorption fingerprint for each compound. This survey of common household and laboratory materials uses the FT-IR spectrometer in ATR mode to capture each sample's spectrum across the mid-infrared range (~550–4000 cm⁻¹), building a reference library of spectra and identifying characteristic functional group signatures in everyday substances.

## Setup

| Category | Details |
|----------|---------|
| Instrument | Thermo Scientific Nicolet 380 FT-IR Spectrometer |
| Mode | Attenuated Total Reflectance (ATR) |
| Range | ~550–4000 cm⁻¹ |
| Resolution | ~7,150 data points per spectrum |
| Runs | Two sessions (19 + 6 samples) |
| Software | Thermo Scientific OMNIC 8 |

A background spectrum was collected first to establish a baseline. Each sample was placed directly on the ATR crystal — in ATR mode, an infrared beam reflects internally within the crystal and an evanescent wave penetrates a few microns into the sample surface, so samples can be measured as-is without any preparation. A spectrum was acquired across the mid-IR range and <a href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy/DATA">the raw CSV</a> exported from OMNIC 8.

## Samples

<div class="hero-single"><img src="PHOTOS/20260404 Samples B.jpeg" alt="Samples"></div>

| Category | Samples |
|----------|---------|
| Solvents | acetone, isopropanol, water |
| Food/minerals | coffee, salt, sugar |
| Personal care | soap, shampoo, conditioner, lotion, sunscreen, cleaner |
| Polymers | plastic bag, plastic cap, plastic glove, plastic wrapper |
| Paper | paper, paper-plastic cup |
| Biological | finger, leaf, orange peel |
| Control | background |

## Data

Raw spectra are available as CSV files each containing two columns (wavenumber in cm⁻¹ and transmittance in %) with ~7,150 data points per spectrum. Data is organized into two experimental runs: <a href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy/DATA/ONE">ONE</a> (19 samples) and <a href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy/DATA/TWO">TWO</a> (6 samples) over two different days.

## Methods

The instrument (Nicolet 380) applies background correction automatically — each sample's transmittance is already measured relative to the background spectrum, so non-absorbing regions read ~100% transmittance. The <a href="https://github.com/vivianweidai/science/blob/main/research/20260401%20IR%20Spectroscopy/OUTPUT/clean_data.py">data cleaning pipeline</a>:

1. **Parse** — raw CSVs use scientific notation with no headers; each file was parsed into numeric wavenumber and transmittance columns.
2. **Convert to absorbance** — transmittance was converted using A = −log₁₀(T/100), where T is transmittance in percent. Absorbance is dimensionless and directly proportional to concentration via the Beer-Lambert law.
3. **Export** — all 23 samples were saved as individual cleaned CSVs with headers (wavenumber, transmittance, absorbance) into a single <a href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy/OUTPUT/SCRUBBED">SCRUBBED</a> folder.

All spectra plots, peak identification, and category overlays were generated from the cleaned data using Python libraries in the <a href="https://github.com/vivianweidai/science/blob/main/research/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">analysis notebook</a>.

## Results

### Representative Samples

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
    <img src="OUTPUT/IMAGES/acetone_spectrum.png" alt="Acetone spectrum" class="result-img">
    <p>Acetone shows a textbook IR spectrum. The dominant peak at ~1,715 cm⁻¹ is the C=O carbonyl stretch — the strongest and most characteristic absorption in ketones. The C–H methyl stretches appear around 2,950–3,000 cm⁻¹, the peaks at ~1,350–1,450 cm⁻¹ are C–H bending (symmetric and asymmetric scissoring of the CH₃ groups), and the sharp peaks in the 1,000–1,300 cm⁻¹ region correspond to C–O and C–C skeletal stretches. The absence of a broad O–H band confirms the sample is anhydrous.</p>
  </div>

  <div class="tab-content" id="content-water">
    <img src="OUTPUT/IMAGES/water_spectrum.png" alt="Water spectrum" class="result-img">
    <p>Water produces the classic broad O–H stretching band centered around 3,300 cm⁻¹, spanning nearly the entire 3,000–3,600 cm⁻¹ region due to hydrogen bonding. The sharp peak at ~1,640 cm⁻¹ is the O–H bending (scissoring) mode. The strong absorption rising below 1,000 cm⁻¹ is the librational (rocking) mode of liquid water.</p>
  </div>

  <div class="tab-content" id="content-salt">
    <img src="OUTPUT/IMAGES/salt_spectrum.png" alt="Salt spectrum" class="result-img">
    <p>Salt (NaCl) is an ionic compound with no covalent bonds, so it produces a nearly flat baseline with no characteristic IR absorptions. The small features visible are likely surface moisture (trace O–H) and atmospheric CO₂ interference. This makes salt an effective negative control and explains why NaCl is traditionally used for IR sample windows.</p>
  </div>

  <div class="tab-content" id="content-plastic">
    <img src="OUTPUT/IMAGES/plastic_bag_spectrum.png" alt="Plastic Bag spectrum" class="result-img">
    <p>Polyethylene (plastic bag) shows an almost pure C–H spectrum. The sharp doublet at ~2,920 and ~2,850 cm⁻¹ corresponds to asymmetric and symmetric C–H stretching of the CH₂ backbone. The C–H bending peaks at ~1,460 cm⁻¹ (scissoring) and ~720 cm⁻¹ (rocking) complete the picture. No O–H, C=O, or other heteroatom peaks — just carbon and hydrogen.</p>
  </div>

  <div class="tab-content" id="content-sugar">
    <img src="OUTPUT/IMAGES/sugar_spectrum.png" alt="Sugar spectrum" class="result-img">
    <p>Sugar (sucrose) shows a broad O–H stretching band at 3,000–3,500 cm⁻¹ from its many hydroxyl groups, plus a rich fingerprint region below 1,500 cm⁻¹ dominated by C–O stretching vibrations of the glycosidic bond and sugar ring. The complexity of the fingerprint region reflects the molecule's size — each sugar has a unique IR fingerprint that can be used for identification.</p>
  </div>
</div>


### Household Categories

<div class="tabs">
  <input type="radio" name="cat-tab" id="cat-solvents">
  <input type="radio" name="cat-tab" id="cat-food">
  <input type="radio" name="cat-tab" id="cat-personal">
  <input type="radio" name="cat-tab" id="cat-polymers">
  <input type="radio" name="cat-tab" id="cat-paper">
  <input type="radio" name="cat-tab" id="cat-biological">

  <div class="cat-tab-labels tab-labels">
    <label for="cat-solvents">Solvents</label>
    <label for="cat-food">Food / Minerals</label>
    <label for="cat-personal">Personal Care</label>
    <label for="cat-polymers">Polymers</label>
    <label for="cat-paper">Paper</label>
    <label for="cat-biological">Biological</label>
  </div>

  <div class="tab-content" id="content-solvents">
    <img src="OUTPUT/IMAGES/solvents_spectrum.png" alt="Solvents spectra" class="result-img">
    <p>Three solvents with very different bonding. <strong>Water</strong> dominates with its broad O–H stretch centered at ~3,300 cm⁻¹ and sharp O–H bend at ~1,640 cm⁻¹. <strong>Isopropanol</strong> combines a broad O–H band (hydrogen-bonded alcohol) with strong C–H stretches at ~2,950 cm⁻¹ and a rich C–O stretching region around 1,000–1,150 cm⁻¹. <strong>Acetone</strong> stands out with its sharp C=O carbonyl peak at ~1,715 cm⁻¹ — the hallmark of a ketone — and no O–H band, confirming it is anhydrous.</p>
  </div>

  <div class="tab-content" id="content-food">
    <img src="OUTPUT/IMAGES/food_minerals_spectrum.png" alt="Food / Minerals spectra" class="result-img">
    <p><strong>Coffee</strong> produces a broad O–H band around 3,300 cm⁻¹ (water and hydroxyl groups in organic acids) plus C=O and C–O absorptions in the fingerprint region from caffeine, chlorogenic acids, and lipids. <strong>Sugar</strong> (sucrose) shows a similarly broad O–H region from its many hydroxyl groups, but its fingerprint region below 1,500 cm⁻¹ is dominated by intense C–O stretching vibrations of the glycosidic bond and sugar ring — each sugar has a unique fingerprint here. <strong>Salt</strong> (NaCl) is the outlier: as a purely ionic compound with no covalent bonds, it produces an almost perfectly flat baseline — no IR-active vibrations to absorb.</p>
  </div>

  <div class="tab-content" id="content-personal">
    <img src="OUTPUT/IMAGES/personal_care_spectrum.png" alt="Personal Care spectra" class="result-img">
    <p>Personal care products are complex mixtures but share common signatures. All six samples show a broad O–H/N–H band at 3,000–3,500 cm⁻¹ from water, glycerin, and fatty alcohols. The C–H stretches at ~2,920/2,850 cm⁻¹ reflect long-chain fatty acids and surfactants. <strong>Soap</strong> and <strong>cleaner</strong> stand out with sharper C–H peaks and stronger fingerprint absorptions, while <strong>shampoo</strong>, <strong>conditioner</strong>, and <strong>lotion</strong> cluster together — unsurprising given their similar water-and-surfactant formulations. <strong>Sunscreen</strong> diverges with additional C=O absorption from UV-filtering compounds.</p>
  </div>

  <div class="tab-content" id="content-polymers">
    <img src="OUTPUT/IMAGES/polymers_spectrum.png" alt="Polymers spectra" class="result-img">
    <p>Four plastic samples show that not all polymers are alike. <strong>Plastic bag</strong> (polyethylene) and <strong>plastic wrapper</strong> both display the classic PE signature: sharp C–H doublet at ~2,920/2,850 cm⁻¹ with minimal other absorptions. <strong>Plastic cap</strong> (polypropylene) adds a methyl C–H shoulder and extra bending peaks. <strong>Plastic glove</strong> (nitrile or vinyl) is the outlier — its spectrum includes C=O, C–O, and possible C≡N stretches, revealing a more complex polymer with heteroatom functional groups.</p>
  </div>

  <div class="tab-content" id="content-paper">
    <img src="OUTPUT/IMAGES/paper_spectrum.png" alt="Paper spectra" class="result-img">
    <p><strong>Paper</strong> is primarily cellulose — the broad O–H stretch at 3,000–3,500 cm⁻¹ comes from hydroxyl groups along the polysaccharide chain, and the strong C–O absorptions at 1,000–1,150 cm⁻¹ are characteristic of the glycosidic linkages. The <strong>paper-plastic cup</strong> overlays a polyethylene coating on the cellulose base: the added C–H stretches at ~2,920/2,850 cm⁻¹ reveal the PE lining, while the underlying O–H and C–O bands from the paper substrate remain visible.</p>
  </div>

  <div class="tab-content" id="content-biological">
    <img src="OUTPUT/IMAGES/biological_spectrum.png" alt="Biological spectra" class="result-img">
    <p>Biological samples are chemically rich. <strong>Finger</strong> (skin) shows amide I (~1,640 cm⁻¹) and amide II (~1,540 cm⁻¹) bands from keratin protein, plus lipid C–H stretches and a broad O–H/N–H region. <strong>Leaf</strong> combines cellulose signatures (O–H, C–O) with cuticle wax C–H peaks and possible chlorophyll absorptions. <strong>Orange peel</strong> is dominated by terpene and essential oil signatures — strong C–H stretches, a C=O band from citric acid or esters, and complex C–O absorptions from pectin and sugars in the rind.</p>
  </div>
</div>


### Chemical Categories

<div class="tabs">
  <input type="radio" name="chem-tab" id="chem-oh">
  <input type="radio" name="chem-tab" id="chem-ch">
  <input type="radio" name="chem-tab" id="chem-co">
  <input type="radio" name="chem-tab" id="chem-mixed">
  <input type="radio" name="chem-tab" id="chem-cellulose">
  <input type="radio" name="chem-tab" id="chem-protein">
  <input type="radio" name="chem-tab" id="chem-ionic">

  <div class="chem-tab-labels tab-labels">
    <label for="chem-oh">O–H Dominant</label>
    <label for="chem-ch">C–H Dominant</label>
    <label for="chem-co">Carbonyl</label>
    <label for="chem-mixed">Organic</label>
    <label for="chem-cellulose">Cellulose</label>
    <label for="chem-protein">Protein</label>
    <label for="chem-ionic">Ionic</label>
  </div>

  <div class="tab-content" id="content-chem-oh">
    <img src="OUTPUT/IMAGES/chem_oh_spectrum.png" alt="O–H dominant spectra" class="result-img">
    <p><strong>Water, coffee, sugar, lotion, shampoo, conditioner</strong> — all share the broad O–H stretching band at 3,200–3,600 cm⁻¹ as their most prominent feature. Whether the hydroxyl comes from liquid water, dissolved sugars, or glycerin in cosmetics, the hydrogen-bonded O–H stretch dominates the spectrum. The fingerprint regions diverge — sugar and coffee show rich C–O patterns while the personal care products are smoother — but the O–H signature ties them together.</p>
  </div>

  <div class="tab-content" id="content-chem-ch">
    <img src="OUTPUT/IMAGES/chem_ch_spectrum.png" alt="C–H dominant spectra" class="result-img">
    <p><strong>Plastic bag, plastic cap, plastic wrapper (×2)</strong> — polyolefin plastics made almost entirely of carbon and hydrogen. The sharp C–H stretching doublet at ~2,920/2,850 cm⁻¹ and C–H bending at ~1,460 cm⁻¹ are virtually the only features. These spectra overlap closely because the underlying polymer (polyethylene or polypropylene) is chemically simple — long hydrocarbon chains with no heteroatoms.</p>
  </div>

  <div class="tab-content" id="content-chem-co">
    <img src="OUTPUT/IMAGES/chem_co_spectrum.png" alt="Carbonyl spectra" class="result-img">
    <p><strong>Acetone, sunscreen</strong> — both produce a strong C=O carbonyl stretch at ~1,715 cm⁻¹. In acetone it's the ketone carbonyl; in sunscreen it's from UV-absorbing compounds (avobenzone, octinoxate) that contain ester or ketone groups. Despite being very different products, the carbonyl peak is the defining spectral feature in both.</p>
  </div>

  <div class="tab-content" id="content-chem-mixed">
    <img src="OUTPUT/IMAGES/chem_mixed_spectrum.png" alt="Mixed organic spectra" class="result-img">
    <p><strong>Isopropanol, soap, cleaner, orange peel</strong> — these samples show multiple functional groups without any single one dominating. Isopropanol has O–H, C–H, and C–O all in balance. Soap and cleaner contain fatty acid salts with C–H chains plus carboxylate groups. Orange peel is a natural mixture of terpenes, citric acid, pectin, and essential oils — producing a busy spectrum with contributions from nearly every region.</p>
  </div>

  <div class="tab-content" id="content-chem-cellulose">
    <img src="OUTPUT/IMAGES/chem_cellulose_spectrum.png" alt="Cellulose spectra" class="result-img">
    <p><strong>Paper, paper (run 2), paper-plastic cup, leaf</strong> — all contain cellulose as the structural backbone. The characteristic pattern is a broad O–H band (hydroxyl groups along the polysaccharide chain) combined with strong C–O stretching at 1,000–1,150 cm⁻¹ from glycosidic linkages. The paper-plastic cup adds polyethylene C–H peaks on top of the cellulose base. Leaf includes additional cuticle wax signatures but the underlying cellulose framework is clearly visible.</p>
  </div>

  <div class="tab-content" id="content-chem-protein">
    <img src="OUTPUT/IMAGES/chem_protein_spectrum.png" alt="Protein / amide spectra" class="result-img">
    <p><strong>Finger (skin), plastic glove</strong> — an unexpected pairing. Human skin (keratin) shows the classic amide I band at ~1,640 cm⁻¹ and amide II at ~1,540 cm⁻¹ from protein peptide bonds. The plastic glove (nitrile or vinyl) also shows amide-like absorptions from its polymer structure. Both spectra feature these mid-range carbonyl/nitrogen bands that distinguish them from the simpler hydrocarbon or hydroxyl-dominated groups.</p>
  </div>

  <div class="tab-content" id="content-chem-ionic">
    <img src="OUTPUT/IMAGES/chem_ionic_spectrum.png" alt="Ionic spectra" class="result-img">
    <p><strong>Salt</strong> — NaCl is purely ionic with no covalent bonds, so it has no IR-active vibrations and produces an essentially flat baseline. The minor features are trace surface moisture and atmospheric CO₂. Salt stands alone as the only sample with no molecular absorption signature — which is precisely why NaCl has historically been used to make IR-transparent windows and pellets.</p>
  </div>
</div>

<script src="/archives/formatting/tabs.js"></script>

See the <a href="https://github.com/vivianweidai/science/blob/main/research/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">static notebook</a> or <a href="https://colab.research.google.com/github/vivianweidai/science/blob/main/research/20260401%20IR%20Spectroscopy/OUTPUT/ir_analysis.ipynb">run the reproducible analysis yourself</a>.

---

<div class="footer"><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/science/tree/main/research/20260401%20IR%20Spectroscopy">View on GitHub</a></div>
