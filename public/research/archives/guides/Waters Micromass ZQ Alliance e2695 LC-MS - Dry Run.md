Waters Micromass ZQ + Alliance e2695 LC-MS — Dry Run (Clickthrough Only)

Goal: confirm vacuum, run LC pumps with mobile phase to waste (no MS spray), launch MassLynx, take a short MS scan with source ESI gases on but LC diverted, save · No injection · No column equilibration

SUPPLIES (minimal)
☐ Bottle of HPLC-grade water + bottle of HPLC-grade methanol or acetonitrile (small volumes; for pump prime + isocratic flow)
☐ Empty waste bottle (dry-run flow goes here, not into the MS)
☐ USB stick for the .raw data folder

The ZQ is older than the Agilent 7890/5975 — pumpdown from vented can take 4–8 hours, so verify the MS is already at vacuum before walking in. The Alliance e2695 wants its solvent inlet lines purged before any flow; the dry run explicitly diverts LC flow to waste, never into the MS source, so source contamination is not a concern.

PRE-VISIT CHECK
☐ Confirm N2 supply on (nebulizer + desolvation gas) — wall regulator ~80–100 psi, or N2 generator running
☐ Confirm roughing pump is running (audible from under the bench)
☐ Confirm MS PC is on and MassLynx 4.1 has been left running, OR be prepared to wait ~5 min for it to launch and connect
☐ Confirm the source is in standby (heater off, gas off) — the ZQ leaves the source idle but powered between users

POWER UP / SOFTWARE
☐ Power on the Alliance e2695 stack (front rocker on the system manager); wait ~3 min for self-test, all module LEDs green
☐ Launch MassLynx 4.1 if not already running; open the default project (or create one named `dryrun_YYYYMMDD`)
☐ MS Console → confirm "Operate" / "Standby" status visible and instrument communicating
☐ Vacuum LEDs / readback: turbo at speed, analyser pressure < 5×10⁻⁵ mbar (acceptable range; if higher, abort — instrument may be venting)

LOAD A TUNE FILE (do NOT autotune)
☐ Tune page → File → Open → select the most recent saved tune file (e.g. `ESI_pos_default.ipr`)
☐ Verify cone voltage, capillary voltage, source temp values populate — do NOT click "Operate" yet
☐ Source temp setpoint typical: 120°C · Desolvation temp: 250°C · Cone gas 50 L/hr · Desolvation gas 400 L/hr
☐ Leave tune in standby (no high voltage, no spray) — we are not running an analyte

PRIME LC + SET ISOCRATIC FLOW (DIVERTED)
☐ At the Alliance front panel: Direct Function → Prime → channel A (water), 5 mL/min for 3 min; repeat for channel B (MeOH or ACN)
☐ Confirm waste line is routed from the column compartment outlet (or from a union if column is removed) DIRECTLY TO WASTE — disconnected from the MS source inlet
☐ MassLynx Inlet Editor → New Method → isocratic 50:50 A/B (water/MeOH), 0.3 mL/min, 5 min total run
☐ No injection programmed — the autosampler can stay parked

START THE MS WITH SOURCE GASES BUT NO SPRAY
☐ MS Console → Operate (turns on source heaters + gas flows ONLY; capillary HV stays off because tune is at standby)
☐ Wait ~3 min for desolvation temp to reach setpoint
☐ Confirm gas LEDs green: nebulizer flowing, desolvation flowing
☐ Acquisition method: full scan ESI+ 100–1000 m/z, 1.0 sec scan time

BLANK RUN
☐ MassLynx Sample List: one row, sample name = `dryrun_blank`, no injection volume, link the Inlet method + MS method
☐ Click Run Samples
☐ Watch chromatogram window: TIC trace populates with low-noise baseline (LC is flowing but going to waste, MS is scanning the air in the source)
☐ Watch LC pressure trace: should stabilize ~50–150 bar with no column, much higher with column
☐ When the 5 min sequence ends, MassLynx auto-saves the .raw folder

SAVE + EXPORT
☐ File → Browse → locate the `dryrun_blank.raw` folder
☐ Copy the entire .raw folder (it's a directory, not a single file) to USB
☐ Optionally export TIC chromatogram as .txt via Chromatogram → Save As → ASCII

SHUTDOWN
☐ Stop LC flow: Inlet → set flow to 0 mL/min, pumps off
☐ MS Console → Standby (kills source gases + heaters, but keeps vacuum)
☐ Close MassLynx (optional — usually left running)
☐ Leave Alliance + ZQ powered (instrument prefers continuous power + vacuum)
☐ Pack out

If the MS reads high pressure (>1×10⁻⁴ mbar) at the start — do NOT click Operate. The system may have lost vacuum. Walk away and report.

If the LC pressure spikes above 400 bar — stop pumps immediately; there is a blockage in the diverted line.

TIMING & BOTTLENECK LOG

| Step | Time | Notes / bottleneck |
|---|---|---|
| Power up + MassLynx online | | |
| Vacuum check | | |
| Tune file load (standby) | | |
| LC prime (A + B) | | |
| Inlet method setup | | |
| Operate source (gas + heat) | | |
| Blank run (~5 min) | | |
| Save + USB export | | |
| Standby + LC off | | |
| TOTAL on-site time | | |

Bottlenecks / supplies that ran short / things to add to next Amazon order:
