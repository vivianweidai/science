---
layout: default
---

<div class="page-header"><h2>Research</h2><a class="back-link" href="/">Science</a></div>

<div class="timeline">
  <div class="year-marker">2026</div>

  <div class="entry">
    <div class="month">April</div>
    <div class="chips-cell"><span class="chip chem">Chemistry</span></div>
    <div class="name-cell"><a href="20260411%20Centrifuge/">Centrifuge</a></div>
    <div class="desc-cell">Centrifugation and pH measurements of everyday liquids</div>
  </div>

  <div class="entry">
    <div class="month">April</div>
    <div class="chips-cell"><span class="chip chem">Chemistry</span></div>
    <div class="name-cell"><a href="20260405%20Melting%20Point/">Melting Point</a></div>
    <div class="desc-cell">Melting point determination of caffeine and aspirin — on hold pending instrument repair</div>
  </div>

  <div class="entry">
    <div class="month">April</div>
    <div class="chips-cell"><span class="chip phys">Physics</span></div>
    <div class="name-cell"><a href="20260404%20Four%20Point%20Probe/">Four-Point Probe</a></div>
    <div class="desc-cell">Sheet resistance measurements of conductive materials</div>
  </div>

  <div class="entry">
    <div class="month">April</div>
    <div class="chips-cell"><span class="chip chem">Chemistry</span></div>
    <div class="name-cell"><a href="20260401%20IR%20Spectroscopy/">IR Spectroscopy</a></div>
    <div class="desc-cell">IR spectroscopy of 19 everyday materials — functional group identification</div>
  </div>

  <div class="entry">
    <div class="month">April</div>
    <div class="chips-cell"><span class="chip bio">Biology</span></div>
    <div class="name-cell"><a href="20260401%20Genes%20in%20Space/">Genes in Space</a></div>
    <div class="desc-cell">Investigating gene expression changes under simulated microgravity conditions</div>
  </div>

  <div class="year-marker">2025</div>

  <div class="entry">
    <div class="month">February</div>
    <div class="chips-cell"><span class="chip comp">Computing</span></div>
    <div class="name-cell"><a href="20250225%20Catfood/">Cat Food Color Preference</a></div>
    <div class="desc-cell">Chi-squared analysis of red vs. green food color preference in a domestic cat</div>
  </div>
</div>

<style>
  .timeline { border-left: 2px solid #d1d9e0; margin-left: .8em; padding-left: 1.2em; }
  .timeline .year-marker { font-weight: 700; font-size: 1.1em; margin: 1.2em 0 .4em 0; }
  .timeline .entry {
    display: grid;
    grid-template-columns: 6.5em auto 1fr;
    gap: 0 .5em;
    padding: .35em 0;
    font-size: .95em;
    align-items: first baseline;
  }
  .timeline .entry .month { color: #656d76; font-variant-numeric: tabular-nums; }
  .timeline .entry .chips-cell { white-space: nowrap; display: flex; gap: 2px; align-items: center; }
  .timeline .entry .name-cell { font-weight: 600; }
  .timeline .entry .name-cell a { color: #1f2328; text-decoration: none; }
  .timeline .entry .name-cell a:hover { text-decoration: underline; }
  .timeline .entry .desc-cell { grid-column: 3; color: #656d76; font-size: .88em; }

  .chip {
    display: inline-block; padding: 1px 7px; border-radius: 999px;
    font-size: .72em; font-weight: 600; color: #1f2328;
    text-align: center; white-space: nowrap; line-height: 1.6;
  }
  .chip.math  { background: #c5d9f7; }
  .chip.comp  { background: #d9ccee; }
  .chip.phys  { background: #f9c4a8; }
  .chip.chem  { background: #cdeaa6; }
  .chip.bio   { background: #b8e0c4; }
  .chip.astro { background: #f4c2cb; }
</style>

## Instruments

- **[Chemistry]** <a href="20260401%20IR%20Spectroscopy/">Thermo Scientific Nicolet 380 FT-IR Spectrometer</a> — mid-IR absorption/transmittance spectra
- **[Chemistry]** <a href="20260405%20Melting%20Point/">OptiMelt Automated Melting Point System</a> — melting point determination
- **[Chemistry]** <a href="20260411%20Centrifuge/">Thermo Scientific Refrigerated Centrifuge</a> — separation of mixtures by density
- **[Chemistry]** <a href="20260411%20Centrifuge/">VWR pH 1100 L</a> — benchtop pH measurements
- **[Physics]** <a href="20260404%20Four%20Point%20Probe/">Jandel RM3 Four-Point Probe</a> — sheet resistance measurements
- **[Biology]** <a href="20260401%20Genes%20in%20Space/">miniPCR Thermal Cycler</a> — PCR amplification of DNA/RNA targets
- **[Biology]** <a href="20260401%20Genes%20in%20Space/">P51 Fluorescence Viewer</a> — fluorescence detection and gel imaging
- **[Biology]** <a href="20260401%20Genes%20in%20Space/">BioBits Cell Free System</a> — in vitro protein expression from DNA templates
- **[Computing]** GitHub, Python and Jupyter Notebooks — statistical analysis and reproducible research pipelines

## Repository Structure

All projects are documented with the folder structure:

```
YYYYMMDD Project Name/
├── DATA/       # Raw instrument data
├── PHOTOS/     # Experiment photos
├── PAPERS/     # Background papers
├── OUTPUT/     # Analysis and reports
└── index.md    # Project summary page
```

---

<div class="footer"><div class="footer-nav"><a href="/curriculum/">Curriculum</a><a href="/olympiads/">Olympiads</a><a href="/research/">Research</a></div><a class="footer-github" href="https://github.com/vivianweidai/science/tree/main/research">View on GitHub</a></div>
