---
project: Liquid Chromatography
toys:
  - Liquid Chromatography
title: "Liquid Chromatography — Dry Run"
sciences:
  - Chemistry
---

<div class="hero-single"><img src="photos/setup/setup1.jpeg" alt="Agilent 1200 Series HPLC System"></div>

<div class="section-heading"><h2>Overview</h2><span class="section-date">April 27th 2026</span></div>

Liquid chromatography pulls a mixture apart into individual compounds in time, then identifies and quantifies each. Pressurized solvent (mobile phase) carries the injected mixture through a column packed with stationary phase; analytes separate by partitioning between the two — stickier molecules elute later. A detector at the outlet records each compound as it elutes, and what kind of detector decides what dimension of information you get back.

**vs. spectroscopy** — IR/UV-Vis interrogate a mixture as one. LC pulls the mixture apart in time first; each peak is a different compound.

<div class="instrument-table no-highlight">

| Instrument | Detector | Tells you | Use case |
|------------|----------|-----------|----------|
| Agilent 1200 Series HPLC System | UV/DAD (absorbance) | Retention time + UV spectrum | Target **quant** — count what you know is there |
| Waters Micromass ZQ Alliance e2695 LC-MS | Single-quad MS | Retention time + nominal mass (±1 Da) | Target **confirm** — mass evidence for a known target |
| Agilent 6230A TOF LC-MS | TOF MS | Retention time + exact mass (~ppm) | Target **discover** — find unknowns |

</div>

Information ladder: absorbance → unit mass → exact mass. Each rung narrows the answer to fewer candidate molecules.

Clickthrough dry run — water through the flow path, **no column, no injection**. Watch pressure stabilize and DAD baseline stay flat. Verifies plumbing and detector before introducing a column and samples.

## Setup

<div class="instrument-table">

| Instrument | Role | Range |
|------------|------|-------|
| Agilent 1200 Series HPLC System | Quaternary pump · autosampler · column compartment · DAD | DAD 190–950 nm |

</div>

| Toolkit | Details |
|---------|---------|
| Mode | Isocratic, 100% A (HPLC-grade water), 0.5 mL/min, 5 min run |
| Column | Removed — replaced with a zero-volume union (skips ~20–30 min equilibration) |
| Detector | DAD — signal A 254 nm, ref 360 nm, scan 200–400 nm |
| Software | Agilent ChemStation |
| Output | `.M` method + `.D` data to USB |

The 1200 stack powers up bottom-to-top — degasser → pump → autosampler → column compartment → DAD — each module handshakes with ChemStation before the next comes online.

## Samples

| Category | Sample |
|----------|--------|
| Blank | None — flow only, no injection |

A real session would inject 1–10 µL from the autosampler tray, run a gradient (e.g. 5% → 95% acetonitrile in water with 0.1% formic acid over 15 min), and read peaks off the DAD trace.

## Method

1. **Power up** — bottom-to-top stack, ~3–5 min, every module "Online / Ready".
2. **Prime / purge** — bottle A full, inlet submerged; purge channel A at 5 mL/min × 3 min.
3. **Method** — isocratic 100% A · 0.5 mL/min · 5 min · DAD 254 nm / ref 360 / scan 200–400 · `dryrun_blank`.
4. **Run** — click Run Method (no injection); watch pressure and baseline settle.
5. **Save** — File → Save Method · Save Data → `.M` + `.D` to USB.
6. **Shutdown** — flow to 0, pump off, DAD lamp off, ChemStation closed, stack powered.

## Expected Results

Short flat chromatogram — no injection, no column → no peaks; pressure should sit stable around 5–20 bar at 0.5 mL/min and DAD baseline should settle within 1–2 min (0 bar = leak; >100 bar = blocked union; drift after warm-up = lamp aging or dirty flow cell). Next session installs a C18 reversed-phase column, equilibrates with a water/acetonitrile gradient, and runs a caffeine + paracetamol mix — the textbook two-peak HPLC test sample.

<div id="technology" class="tech-table-wrap">
<div class="tech-table">
<div class="tech-table-header">Technology</div>
<ul class="updates-list">
  <li class="fade-in" data-subj="chem"><span class="update-date">Separation</span> <span class="update-name"><a href="/research/toys/chemistry/Liquid Chromatography/">Liquid Chromatography</a></span> <span class="update-desc">Flow through packed column — separate by chemical affinity</span> <a class="chip chem" href="/research/#chem">Chemistry</a></li>
</ul>
</div>
</div>
