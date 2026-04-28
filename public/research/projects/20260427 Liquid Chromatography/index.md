---
project: Liquid Chromatography
---


<div class="project-title"><h1>Liquid Chromatography — Dry Run</h1><a class="chip chem" href="/curriculum/#chemistry">Chemistry</a></div>

<div class="hero-single"><img src="photos/setup/setup1.jpeg" alt="Agilent 1200 Series HPLC System"></div>

<div class="section-heading"><h2>Overview</h2><span class="section-date">April 27th 2026</span></div>

Liquid chromatography pushes a pressurized solvent (mobile phase) through a column packed with stationary phase; analytes separate by partitioning between the two as they travel. A detector at the column outlet records each compound as it elutes — UV absorbance for the diode-array detector here, mass for an LC-MS configuration.

- **HPLC** — same hardware as LC-MS, minus the mass-spec detector. The DAD reports a chromatogram (absorbance vs. time) at chosen wavelengths.
- **Differentiator vs. spectroscopy** — IR and UV-Vis interrogate a sample as a single mixture; HPLC pulls the mixture apart in time first, so each peak in the chromatogram is a different compound.

This page is the **clickthrough dry run** — prime the pump, run pure water through the flow path with no column, watch the pressure trace stabilize and the DAD baseline stay flat. No injection, no separation. The point is to verify the full plumbing-and-detector stack before introducing a column and samples.

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
| Detector | Diode-Array Detector — signal A at 254 nm, ref 360 nm, scan 200–400 nm |
| Software | Agilent ChemStation |
| Output | Method (`.M`) + data (`.D`) to USB |

The 1200 stack powers up bottom-to-top — degasser, then quaternary pump, then autosampler, then column compartment, then DAD — each module needs a moment to handshake with ChemStation before the next comes online. With the column out and pure water flowing, the system is doing roughly nothing chemically; that's the point.

## Samples

| Category | Sample |
|----------|--------|
| Blank | None — flow only, no injection |

A real session would inject 1–10 µL of analyte from the autosampler vial tray, run a gradient (e.g. 5% → 95% acetonitrile in water with 0.1% formic acid over 15 min), and read peaks off the DAD trace. The dry run skips injection entirely.

## Method

The clickthrough, in order:

1. **Power up stack** — degasser → pump → autosampler → column compartment → DAD; ~3–5 min for all modules to initialize; ChemStation shows every module "Online / Ready".
2. **Prime / purge** — confirm bottle A (HPLC water) full and inlet line submerged; open pump purge valve; Pump → Purge channel A at 5 mL/min × 3 min; close purge valve.
3. **Method** — New Method · isocratic 100% A · 0.5 mL/min · 5 min total · DAD signal A 254 nm / ref 360 nm / scan 200–400 nm · sample name `dryrun_blank`.
4. **Run** — click Run Method (no injection); watch pressure stabilize and DAD baseline settle.
5. **Save** — File → Save Method, Save Data → export `.M` + `.D` to USB.
6. **Shutdown** — flow to 0 mL/min, pump off, DAD lamp off, close ChemStation, leave stack powered.

## Expected Results

A short flat chromatogram. No injection, no column → no peaks. What we are checking:

| Check | Pass criterion | Failure mode |
|-------|----------------|--------------|
| Solvent path primed | No air bubbles visible at the pump inlet after purge | Pulsing pressure trace → repeat purge, check inlet frit |
| Pressure pressurizes | Stable ~5–20 bar at 0.5 mL/min with no column | 0 bar → leak or open fitting; >100 bar → blocked union |
| DAD lamp warm | Signal at 254 nm settles to a flat baseline within 1–2 min | Drifting baseline after warm-up → lamp aging or dirty flow cell |
| Modules report | Pump, autosampler, column oven, DAD all "Ready" through the run | "Not Ready" mid-run → one module dropped, restart from that module up |
| File write | `.M` method and `.D` data both export to USB and re-open in ChemStation | Open errors → check ChemStation export preset |

The next session installs a C18 reversed-phase column, equilibrates with a water/acetonitrile gradient, and runs a caffeine + paracetamol mix as a calibration injection — a textbook two-peak HPLC test sample.

<h2 id="extensions">Extensions</h2>

<div class="instrument-table no-highlight">

| Instrument | Extension | Description |
|------------|-----------|-------------|
| [Agilent 6230A TOF LC-MS](photos/setup/setup2.jpeg) 📷 | Detection | Same pump and column up front, mass-spec detector instead of UV — measure the m/z of every eluting peak |
| Waters Micromass ZQ Alliance e2695 LC-MS | Configuration | Alternative LC-MS stack (Waters pump + single-quadrupole MS) for cross-checks |
| Perkin Elmer Series 200 HPLC | Stack | Second walk-up HPLC available — useful for parallel runs or method portability checks |

</div>

