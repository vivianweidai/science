"""UV-Vis Spectroscopy analysis pipeline — pilot run on partial Session 01 data.

Canonical spectroscopy chart style (shared with IR Spectroscopy):
  figsize=(12, 5), linewidth=0.8, top/right spines hidden, y-grid only,
  colored wavelength-region shading with rotated labels, peak λmax
  annotations drawn on the chart. One PNG per sample; tabs on the page.
"""

from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
import matplotlib.ticker as ticker
from scipy.signal import find_peaks

ROOT = Path(__file__).resolve().parent.parent
DATA_ONE = ROOT / "data" / "one"
DATA_TWO = ROOT / "data" / "two"
IMG = ROOT / "output" / "images"
IMG.mkdir(parents=True, exist_ok=True)

# Visible-light rainbow regions for UV-Vis (nm, label, fill color).
# Deep UV + NIR are left unshaded. Colors are light/pastel to match the
# repo chart palette.
REGIONS = [
    (200, 380, "UV",      "#e8eaf0"),
    (380, 450, "violet",  "#d9ccee"),
    (450, 495, "blue",    "#c5d9f7"),
    (495, 570, "green",   "#d4e8a0"),
    (570, 590, "yellow",  "#fff3a8"),
    (590, 620, "orange",  "#f9c4a8"),
    (620, 750, "red",     "#f4c2cb"),
]

TRACE = "#d95f5f"
PALETTE = ["#d95f5f", "#5b9bd5", "#70ad47", "#ed7d31", "#9b59b6", "#e6a532"]


def load_uvvis(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path, skiprows=2, header=None, names=["wavelength_nm", "absorbance"])
    df = df.dropna().astype(float)
    df = df[(df["wavelength_nm"] >= 190) & (df["wavelength_nm"] <= 800)]
    return df.sort_values("wavelength_nm").reset_index(drop=True)


def load_fluoromax(path: Path) -> pd.DataFrame:
    df = pd.read_csv(path, skiprows=2, header=None, names=["wavelength_nm", "signal"])
    return df.dropna().astype(float).reset_index(drop=True)


UVVIS_SAMPLES = {
    # slug -> (display title, filename, (lo, hi) window for primary peak)
    "yellow_neat":   ("Yellow highlighter (distilled water)",     "20260417_UVVis_S2_yellow_rep1.txt",    (300, 600)),
    "yellow_dilute": ("Yellow highlighter (1 drop / 3 mL water)",  "20260417_UVVis_S2_yellow_1drop.txt",   (220, 600)),
    "pink":          ("Pink highlighter (distilled water)",        "20260417_UVVis_S3_pink.txt",           (300, 700)),
    "curcumin":      ("Curcumin (ethanol)",                        "20260417_UVVis_S4_curcumin.txt",       (300, 600)),
    "greentea":      ("Green tea extract (ethanol)",               "20260417_UVVis_S5_greentea.txt",       (220, 750)),
    "salicylate":    ("Salicylate (aspirin + baking soda, distilled water)", "20260417_UVVis_S6_salicylate.txt", (210, 500)),
}


def annotate_regions(ax):
    ylo, yhi = ax.get_ylim()
    for lo, hi, label, color in REGIONS:
        ax.axvspan(lo, hi, alpha=0.35, color=color, zorder=0)
        ax.text((lo + hi) / 2, yhi * 0.95, label,
                ha="center", va="top", fontsize=7, rotation=90, color="#555")


def fmt(ax):
    ax.set_xlim(200, 750)
    ax.xaxis.set_major_formatter(ticker.FuncFormatter(lambda x, p: f"{x:,.0f}"))
    ax.set_xlabel("Wavelength (nm)")
    ax.set_ylabel("Absorbance")
    ax.spines[["top", "right"]].set_visible(False)
    ax.grid(axis="y", alpha=0.3)


def find_primary_peak(df, lo, hi):
    mask = (df.wavelength_nm >= lo) & (df.wavelength_nm <= hi)
    sub = df[mask].reset_index(drop=True)
    sub = sub[sub.absorbance < 4.9]
    if sub.empty:
        return None, None
    peaks, props = find_peaks(sub.absorbance.values, prominence=0.02, distance=20)
    if not len(peaks):
        i = int(sub.absorbance.idxmax())
        return float(sub.wavelength_nm.iloc[i]), float(sub.absorbance.iloc[i])
    idx = peaks[np.argmax(props["prominences"])]
    return float(sub.wavelength_nm.iloc[idx]), float(sub.absorbance.iloc[idx])


def plot_single(slug, title, filename, window):
    df = load_uvvis(DATA_ONE / filename)
    # Clip saturated points (detector pin at A=5) to keep y-axis readable.
    df_plot = df.copy()
    df_plot.loc[df_plot.absorbance > 4.9, "absorbance"] = np.nan

    fig, ax = plt.subplots(figsize=(12, 5))
    ax.plot(df_plot.wavelength_nm, df_plot.absorbance, color=TRACE, linewidth=0.8)

    # Set ylim based on the chemically interesting window (ignore deep-UV
    # noise spikes that would otherwise dominate the scale).
    lo, hi = window
    win = df_plot[(df_plot.wavelength_nm >= lo) & (df_plot.wavelength_nm <= hi)]
    visible_max = win.absorbance.dropna().max() if win.absorbance.notna().any() else 1
    ax.set_ylim(-0.02, max(visible_max * 1.25, 0.5))

    peak_nm, peak_a = find_primary_peak(df, *window)
    fmt(ax)
    annotate_regions(ax)

    if peak_nm is not None and peak_a < 4.9:
        ylo, yhi = ax.get_ylim()
        ax.text(
            peak_nm + 35, peak_a + (yhi - peak_a) * 0.15,
            f"λmax = {peak_nm:.0f} nm   A = {peak_a:.2f}",
            color=TRACE, fontsize=9, fontweight="bold",
            va="center", ha="left",
        )

    ax.set_title(title)
    plt.tight_layout()
    fig.savefig(IMG / f"uvvis_{slug}.png", dpi=300, bbox_inches="tight")
    plt.close(fig)
    return {"sample": title, "lambda_max_nm": peak_nm, "A_at_peak": peak_a}


OVERLAY_SLUGS = ["curcumin", "yellow_neat", "pink", "greentea"]


def plot_overlay():
    fig, ax = plt.subplots(figsize=(12, 5))
    for slug, color in zip(OVERLAY_SLUGS, PALETTE):
        title, fname, _ = UVVIS_SAMPLES[slug]
        df = load_uvvis(DATA_ONE / fname)
        df_plot = df.copy()
        df_plot.loc[df_plot.absorbance > 4.9, "absorbance"] = np.nan
        ax.plot(df_plot.wavelength_nm, df_plot.absorbance,
                color=color, linewidth=0.8, label=title)
    ax.set_ylim(-0.05, 1.2)
    fmt(ax)
    annotate_regions(ax)
    ax.set_title("UV-Vis absorption — pilot samples (saturated regions clipped)")
    ax.legend(fontsize=8, loc="upper right")
    plt.tight_layout()
    fig.savefig(IMG / "uvvis_overlay.png", dpi=300, bbox_inches="tight")
    plt.close(fig)


def plot_fluoromax():
    em = load_fluoromax(DATA_TWO / "20260417_S2_yellow_EM_ex488.csv")
    ex = load_fluoromax(DATA_TWO / "20260417_S2_yellow_EX_em515.csv")

    fig, ax = plt.subplots(figsize=(12, 5))
    em_n = em.signal / em.signal.max()
    ex_n = ex.signal / ex.signal.max()
    ax.plot(ex.wavelength_nm, ex_n, color="#5b9bd5", linewidth=0.8,
            label="Excitation")
    ax.plot(em.wavelength_nm, em_n, color=TRACE, linewidth=0.8,
            label="Emission")

    em_peak = em.loc[em.signal.idxmax(), "wavelength_nm"]
    ex_peak = ex.loc[ex.signal.idxmax(), "wavelength_nm"]
    stokes = em_peak - ex_peak

    ax.set_ylim(-0.05, 1.2)
    ax.xaxis.set_major_formatter(ticker.FuncFormatter(lambda x, p: f"{x:,.0f}"))
    ax.set_xlim(200, 750)
    ax.set_xlabel("Wavelength (nm)")
    ax.set_ylabel("Normalized signal (0\u20131)")
    ax.spines[["top", "right"]].set_visible(False)
    ax.grid(axis="y", alpha=0.3)
    annotate_regions(ax)

    ax.text(0.02, 0.95, f"ex λmax = {ex_peak:.0f} nm",
            transform=ax.transAxes, fontsize=9, color="#5b9bd5",
            fontweight="bold", va="top", ha="left")
    ax.text(0.02, 0.88, f"em λmax = {em_peak:.0f} nm",
            transform=ax.transAxes, fontsize=9, color=TRACE,
            fontweight="bold", va="top", ha="left")
    ax.text(0.02, 0.81, f"Stokes shift: {stokes:.0f} nm",
            transform=ax.transAxes, fontsize=9, color="#333",
            fontweight="bold", va="top", ha="left")

    ax.set_title("Yellow highlighter — FluoroMax-3 excitation + emission")
    ax.legend(loc="upper right", fontsize=8)
    plt.tight_layout()
    fig.savefig(IMG / "fluoromax_yellow.png", dpi=300, bbox_inches="tight")
    plt.close(fig)
    return {"excitation_peak_nm": float(ex_peak),
            "emission_peak_nm": float(em_peak),
            "stokes_shift_nm": float(stokes)}


def main():
    records = []
    for slug, (title, fname, window) in UVVIS_SAMPLES.items():
        r = plot_single(slug, title, fname, window)
        records.append(r)
        print(f"{slug:14s} λmax = {r['lambda_max_nm']} nm  A = {r['A_at_peak']}")

    plot_overlay()

    peaks_df = pd.DataFrame(records)
    peaks_df["D = A / 0.05"] = (peaks_df["A_at_peak"] / 0.05).round(1)
    peaks_df.to_csv(ROOT / "output" / "uvvis_peaks.csv", index=False)

    fluo = plot_fluoromax()
    print("\nFluoroMax-3 (yellow HL):")
    for k, v in fluo.items():
        print(f"  {k}: {v}")


if __name__ == "__main__":
    main()
