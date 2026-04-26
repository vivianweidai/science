---
layout: project
project: IR Spectroscopy
---

<div class="page-header"><h2>Research</h2><div class="header-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div></div>

<div class="project-title"><h1>IR Spectroscopy of Everyday Materials</h1><span class="chip chem">Chemistry</span></div>

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="Experiment photo">
  <img id="photo-1" alt="Experiment photo">
  <img id="photo-2" alt="Experiment photo">
  <img id="photo-3" alt="Experiment photo">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">Shuffle Photos</button>

<div class="section-heading"><h2>Overview</h2><span class="section-date">April 19th 2026</span></div>

Twenty-one everyday materials, one instrument, one question: which bonds are in there?

IR Spectroscopy identifies the polar covalent bonds in a material by measuring which infrared frequencies it absorbs. Different functional groups — O-H, C=O, C-H, N-H — vibrate at characteristic frequencies, producing a unique absorption fingerprint for each compound.

## Setup

<div class="hero-single"><img src="photos/setup/setup8.jpeg" alt="IR setup"></div>

<div class="instrument-table">

| Instrument | Role | Range |
|------------|------|-------|
| Thermo Scientific Nicolet 380 FT-IR Spectrometer | Bulk samples | ~550–4000 cm⁻¹ |

</div>

| Toolkit | Details |
|---------|---------|
| Mode | Attenuated Total Reflectance (ATR) — sample pressed onto the diamond crystal |
| Samples | 21 — solvents, food/minerals, personal care, polymers, paper, biological, control |
| Software | Thermo Scientific OMNIC 8 |

A background spectrum was collected first. The IR beam reflects inside the diamond crystal, an evanescent wave penetrating microns into the pressed sample — no prep, measure as-is.

## Samples

<div class="hero-single"><img src="photos/samples/samples2.jpeg" alt="Samples"></div>

| Category | Samples |
|----------|---------|
| Solvents | acetone, isopropanol, water |
| Food/minerals | coffee, salt, sugar |
| Personal care | soap, shampoo, conditioner, lotion, sunscreen, cleaner |
| Polymers | plastic bag, plastic cap, plastic glove, plastic wrapper |
| Paper | paper, paper-plastic cup |
| Biological | finger, leaf, orange peel |
| Control | background |

## Method

The Nicolet 380 applies background correction automatically — non-absorbing regions read ~100% transmittance. Raw spectra export to <a href="https://github.com/vivianweidai/science/tree/main/public/research/projects/20260419%20IR%20Spectroscopy/data" rel="noopener">CSV</a>, two columns per row (wavenumber in cm⁻¹, transmittance in %). The data-cleaning <a href="https://github.com/vivianweidai/science/blob/main/public/research/projects/20260419%20IR%20Spectroscopy/output/clean_data.py" rel="noopener">pipeline</a>:

1. **Parse** — raw CSVs use scientific notation with no headers; each file was parsed into numeric wavenumber and transmittance columns.
2. **Convert to absorbance** — transmittance was converted using A = −log₁₀(T/100), where T is transmittance in percent. Absorbance is dimensionless and directly proportional to concentration via the Beer-Lambert law.
3. **Export** — all 21 samples were saved as individual cleaned CSVs with headers (wavenumber, transmittance, absorbance) into a single <a href="https://github.com/vivianweidai/science/tree/main/public/research/projects/20260419%20IR%20Spectroscopy/output/scrubbed" rel="noopener">scrubbed</a> folder.

All spectra plots, peak identification, and category overlays were generated from the cleaned data using Python libraries in the analysis <a href="https://github.com/vivianweidai/science/blob/main/public/research/projects/20260419%20IR%20Spectroscopy/output/ir_analysis.ipynb" rel="noopener">notebook</a> and are reproducible on <a href="https://colab.research.google.com/github/vivianweidai/science/blob/main/public/research/projects/20260419%20IR%20Spectroscopy/output/ir_analysis.ipynb" rel="noopener">colab</a>.

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
    <img src="output/images/acetone_spectrum.png" alt="Acetone spectrum" class="result-img">
    <p>The textbook ketone: sharp C=O at ~1,715 cm⁻¹ dominates. Methyl C–H stretches at 2,950–3,000 cm⁻¹, CH₃ bending at 1,350–1,450 cm⁻¹, C–O/C–C skeletal peaks at 1,000–1,300 cm⁻¹. No broad O–H — confirms anhydrous.</p>
  </div>

  <div class="tab-content" id="content-water">
    <img src="output/images/water_spectrum.png" alt="Water spectrum" class="result-img">
    <p>One giant O–H feature: the broad 3,000–3,600 cm⁻¹ hydrogen-bonded stretch centered at ~3,300 cm⁻¹. Sharp O–H bend at ~1,640 cm⁻¹; strong librational (rocking) absorption rising below 1,000 cm⁻¹.</p>
  </div>

  <div class="tab-content" id="content-salt">
    <img src="output/images/salt_spectrum.png" alt="Salt spectrum" class="result-img">
    <p>The null case. NaCl is purely ionic — no covalent bonds, no IR-active vibrations, no peaks. The tiny features are surface moisture and atmospheric CO₂. Exactly why NaCl is the classical IR-window material.</p>
  </div>

  <div class="tab-content" id="content-plastic">
    <img src="output/images/plastic_bag_spectrum.png" alt="Plastic Bag spectrum" class="result-img">
    <p>Pure hydrocarbon. Polyethylene's CH₂ backbone gives a sharp doublet at ~2,920/2,850 cm⁻¹ (asym/sym stretches), bending at ~1,460 cm⁻¹ (scissor) and ~720 cm⁻¹ (rock). No heteroatom peaks — only C and H.</p>
  </div>

  <div class="tab-content" id="content-sugar">
    <img src="output/images/sugar_spectrum.png" alt="Sugar spectrum" class="result-img">
    <p>Hydroxyl-dense. Sucrose's many –OH groups give a broad 3,000–3,500 cm⁻¹ O–H band, and the fingerprint region below 1,500 cm⁻¹ is packed with glycosidic-bond and ring C–O stretches unique to each sugar.</p>
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
    <img src="output/images/solvents_spectrum.png" alt="Solvents spectra" class="result-img">
    <p>Three solvents, three bonding regimes. <strong>Water</strong> — broad O–H at ~3,300 cm⁻¹, sharp bend at 1,640 cm⁻¹. <strong>Isopropanol</strong> — O–H + C–H at ~2,950 + C–O at 1,000–1,150 cm⁻¹. <strong>Acetone</strong> — sharp ketone C=O at 1,715 cm⁻¹, no O–H.</p>
  </div>

  <div class="tab-content" id="content-food">
    <img src="output/images/food_minerals_spectrum.png" alt="Food / Minerals spectra" class="result-img">
    <p><strong>Coffee</strong> — broad O–H + C=O/C–O from caffeine, chlorogenic acids, lipids. <strong>Sugar</strong> — broad O–H from many –OH groups; dense glycosidic C–O fingerprint below 1,500 cm⁻¹. <strong>Salt</strong> — the outlier, purely ionic, flat baseline.</p>
  </div>

  <div class="tab-content" id="content-personal">
    <img src="output/images/personal_care_spectrum.png" alt="Personal Care spectra" class="result-img">
    <p>Shared base: broad O–H/N–H at 3,000–3,500 cm⁻¹ (water, glycerin, fatty alcohols) + C–H at 2,920/2,850 cm⁻¹ (fatty acids, surfactants). <strong>Shampoo/conditioner/lotion</strong> cluster — same water-surfactant backbone. <strong>Soap/cleaner</strong> — sharper C–H, stronger fingerprint. <strong>Sunscreen</strong> — adds C=O from UV filters.</p>
  </div>

  <div class="tab-content" id="content-polymers">
    <img src="output/images/polymers_spectrum.png" alt="Polymers spectra" class="result-img">
    <p>Not all polymers are alike. <strong>Plastic bag + wrapper</strong> — polyethylene, pure CH₂ doublet at 2,920/2,850 cm⁻¹. <strong>Plastic cap</strong> — polypropylene, adds a methyl shoulder and extra bending peaks. <strong>Plastic glove</strong> — nitrile/vinyl outlier with C=O, C–O, possibly C≡N; heteroatom functional groups.</p>
  </div>

  <div class="tab-content" id="content-paper">
    <img src="output/images/paper_spectrum.png" alt="Paper spectra" class="result-img">
    <p><strong>Paper</strong> — pure cellulose: broad O–H at 3,000–3,500 cm⁻¹ + strong C–O at 1,000–1,150 cm⁻¹ (glycosidic linkages). <strong>Paper-plastic cup</strong> — same cellulose base with PE C–H stretches layered on top, exposing the lining.</p>
  </div>

  <div class="tab-content" id="content-biological">
    <img src="output/images/biological_spectrum.png" alt="Biological spectra" class="result-img">
    <p>Chemically rich. <strong>Finger</strong> — keratin amide I (1,640) + amide II (1,540 cm⁻¹), plus lipid C–H and broad O–H/N–H. <strong>Leaf</strong> — cellulose backbone + cuticle-wax C–H + possible chlorophyll. <strong>Orange peel</strong> — terpene-heavy: C–H, C=O from citric acid/esters, C–O from pectin and rind sugars.</p>
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
    <img src="output/images/chem_oh_spectrum.png" alt="O–H dominant spectra" class="result-img">
    <p><strong>Water, coffee, sugar, lotion, shampoo, conditioner</strong> — broad 3,200–3,600 cm⁻¹ O–H is the loudest signal, whether from liquid water, dissolved sugars, or cosmetic glycerin. Fingerprint regions diverge (sugar/coffee rich in C–O; personal care smoother), but the O–H signature ties them.</p>
  </div>

  <div class="tab-content" id="content-chem-ch">
    <img src="output/images/chem_ch_spectrum.png" alt="C–H dominant spectra" class="result-img">
    <p><strong>Plastic bag, cap, wrapper</strong> — polyolefins, nearly pure hydrocarbon. Sharp 2,920/2,850 cm⁻¹ doublet + 1,460 cm⁻¹ bending are almost the whole spectrum; the PE/PP backbone carries no heteroatoms, so spectra overlap tightly.</p>
  </div>

  <div class="tab-content" id="content-chem-co">
    <img src="output/images/chem_co_spectrum.png" alt="Carbonyl spectra" class="result-img">
    <p><strong>Acetone, sunscreen</strong> — C=O at ~1,715 cm⁻¹ defines both. Acetone's is the ketone carbonyl; sunscreen's comes from ester/ketone groups in UV filters (avobenzone, octinoxate). Different products, same dominant peak.</p>
  </div>

  <div class="tab-content" id="content-chem-mixed">
    <img src="output/images/chem_mixed_spectrum.png" alt="Mixed organic spectra" class="result-img">
    <p><strong>Isopropanol, soap, cleaner, orange peel</strong> — no single peak wins. Isopropanol balances O–H + C–H + C–O. Soap/cleaner — fatty acid salts, C–H chains + carboxylate. Orange peel — natural terpene/citric-acid/pectin mixture, busy across every region.</p>
  </div>

  <div class="tab-content" id="content-chem-cellulose">
    <img src="output/images/chem_cellulose_spectrum.png" alt="Cellulose spectra" class="result-img">
    <p><strong>Paper, paper-plastic cup, leaf</strong> — shared cellulose backbone: broad O–H + glycosidic C–O at 1,000–1,150 cm⁻¹. Cup layers PE C–H on top; leaf layers cuticle wax. The cellulose frame stays legible through both.</p>
  </div>

  <div class="tab-content" id="content-chem-protein">
    <img src="output/images/chem_protein_spectrum.png" alt="Protein / amide spectra" class="result-img">
    <p><strong>Finger, plastic glove</strong> — unlikely pair, same bands. Skin keratin gives textbook amide I (1,640) + amide II (1,540 cm⁻¹); the glove's nitrile/vinyl polymer produces amide-like absorptions from its own N–H/C=O. Both break the hydrocarbon/hydroxyl mold.</p>
  </div>

  <div class="tab-content" id="content-chem-ionic">
    <img src="output/images/chem_ionic_spectrum.png" alt="Ionic spectra" class="result-img">
    <p><strong>Salt</strong> — NaCl has no covalent bonds, so no IR-active vibrations, so a flat baseline. The only sample with no molecular signature — and the reason NaCl has historically made IR-transparent windows and pellets.</p>
  </div>
</div>

<h2 id="extensions">Extensions</h2>

<div class="photo-grid three-col">
  <img src="photos/setup/setup14.jpeg" alt="Bruker Tensor 27 Hyperion FT-IR Microscope">
  <img src="photos/setup/setup9.jpeg" alt="Mettler Toledo ReactIR iC10">
  <img src="photos/setup/setup13.jpeg" alt="Renishaw inVia Raman Microscope">
</div>

<div class="instrument-table no-highlight">

| Instrument | Extension | Description |
|------------|------|-------------|
| [Bruker Tensor 27 Hyperion FT-IR Microscope](photos/setup/setup14.jpeg) 📷 | Space | Scan IR spectrum at microscopic spot |
| [Mettler Toledo ReactIR iC10](photos/setup/setup9.jpeg) 📷 | Time | Produce IR spectrum as reaction proceeds |
| [Renishaw inVia Raman Microscope](photos/setup/setup13.jpeg) 📷 | Chemistry | Detect non-polar bonds |

</div>
