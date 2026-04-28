---
project: Mass Spectrometry
---


<div class="project-title"><h1>Mass Spectrometry — Dry Run</h1><a class="chip chem" href="/curriculum/#chemistry">Chemistry</a></div>

<div class="photo-grid" id="photo-grid">
  <img id="photo-0" alt="Experiment photo">
  <img id="photo-1" alt="Experiment photo">
  <img id="photo-2" alt="Experiment photo">
  <img id="photo-3" alt="Experiment photo">
</div>
<button class="shuffle-btn" onclick="shufflePhotos()">Shuffle Photos</button>

<div class="section-heading"><h2>Overview</h2><span class="section-date">April 27th 2026</span></div>

Mass spectrometry weighs molecules. A short laser pulse vaporizes and ionizes the sample off a metal target plate; ions accelerate down a vacuum flight tube and the time of flight maps to mass-to-charge (m/z) — heavier ions arrive later. The output is a mass spectrum: peaks at the m/z of every detected ion.

- **MALDI** — solid sample dried on a plate, ionized directly by a UV laser (matrix-assisted in production, neat for this dry run). No column upstream.
- **GC-MS / LC-MS** — same idea, but the ion source sits at the end of a chromatograph: each peak that elutes off the column is ionized and weighed in turn. MALDI trades that separation dimension for speed and minimal sample prep.

This page is the **clickthrough dry run** — load an empty plate, fire the laser at a clean spot, save the spectrum. No analyte, no matrix. The point is to verify the full path end-to-end before introducing real samples.

## Setup

<div class="hero-single"><img src="photos/setup/setup4.jpeg" alt="Shimadzu MALDI-8020 MALDI-TOF Mass Spectrometer"></div>

<div class="instrument-table">

| Instrument | Role | Range |
|------------|------|-------|
| Shimadzu MALDI-8020 MALDI-TOF Mass Spectrometer | Benchtop linear MALDI-TOF | 500–3000 m/z |

</div>

| Toolkit | Details |
|---------|---------|
| Mode | Linear positive ion |
| Vacuum | Built-in pump — pumpdown ~3–5 min (vs ~15–20 on older AXIMA) |
| Software | MALDIsolutions |
| Method | Default Linear Positive · laser power 30/180 · 50 shots · 1 profile |
| Output | `.lcd` / `.run` to USB |

The MALDI-8020 is the SIL's walk-up benchtop — single-button vent/pumpdown, no separate roughing pump to babysit, no source bake-out. Plate cleaned with methanol on a lint-free wipe; loaded gloved; venting and pumping driven entirely from MALDIsolutions.

## Samples

| Category | Sample |
|----------|--------|
| Blank | Clean target plate, no analyte, no matrix |

A real session would deposit 1 µL of analyte onto a target spot, dry, overlay 1 µL of matrix solution (sinapinic acid for proteins, CHCA for peptides, DHB for small molecules), dry again, then load. The dry run skips matrix entirely — the laser fires onto bare polished steel.

## Method

The clickthrough, in order:

1. **Power up** — rear switch on; status LED steady (~2 min); MALDIsolutions launched; instrument shows "Ready"; laser interlock confirms "Safe" with chamber lid closed.
2. **Load plate** — Sample → Vent (~30–60 s to atmosphere); drawer open; clean target slid in; drawer closed; Sample → Pump Down (~3–5 min back to operating vacuum).
3. **Method** — Method Editor → load default Linear Positive · laser 30/180 · 50 shots · 1 profile · 500–3000 m/z.
4. **Acquire** — Acquisition window; camera view; pick a clean spot on the empty plate; click Acquire — laser fires, spectrum window populates.
5. **Save** — File → Save → `.lcd`/`.run` to USB.
6. **Shutdown** — Vent, remove plate, pump back down (instrument is happiest stored under vacuum); leave instrument powered.

## Expected Results

A flat baseline across 500–3000 m/z. No analyte, no matrix → no real peaks. What we are checking:

| Check | Pass criterion | Failure mode |
|-------|----------------|--------------|
| Vacuum reaches operating pressure | Pumpdown completes in ~3–5 min, MALDIsolutions clears the "venting" / "pumping" indicator | Stuck pumping → seal leak or chamber not seated |
| Laser fires on command | Spectrum window populates after Acquire; detector trace updates | Static window → laser interlock or HV not enabled |
| Detector alive | Baseline shows expected electronic noise floor across 500–3000 m/z | Dead-flat zero or pinned saturation → detector or amplifier fault |
| File write | `.lcd`/`.run` saves to USB and re-opens cleanly | Format mismatch → check MALDIsolutions export preset |

If real peaks appear, the plate isn't clean — note it, re-wipe with methanol, retry. Not blocking for the dry run.

The next session deposits a calibration peptide standard (e.g. bradykinin / angiotensin mix) with CHCA matrix, switches to Reflectron mode for sub-Da resolution, and recalibrates the m/z axis from the known peptide masses.

<h2 id="extensions">Extensions</h2>

<div class="photo-grid">
  <img src="photos/setup/setup2.jpeg" alt="Agilent 7890A GC 5975C Inert MSD">
  <img src="photos/setup/setup3.jpeg" alt="Agilent 6230A TOF LC-MS">
</div>

<div class="instrument-table no-highlight">

| Instrument | Extension | Description |
|------------|-----------|-------------|
| [Agilent 7890A GC 5975C Inert MSD](photos/setup/setup2.jpeg) 📷 | Volatiles | GC column upstream, electron-impact ionization — fragment fingerprints for small volatile molecules |
| [Agilent 6230A TOF LC-MS](photos/setup/setup3.jpeg) 📷 | Nonvolatiles | LC column upstream, electrospray ionization — intact mass for nonvolatile and thermally fragile compounds |

</div>

