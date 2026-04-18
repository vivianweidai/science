"""UV Spectroscopy analysis pipeline — pilot run on partial Session 01 data.

Loads the UV-2550 absorbance scans (data/one) and the FluoroMax-3 emission /
excitation pair (data/two), finds peaks, computes FluoroMax dilution factors,
and writes figures to output/images/.
"""

from pathlib import Path
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from scipy.signal import find_peaks

ROOT = Path(__file__).resolve().parent.parent
DATA_ONE = ROOT / "data" / "one"
DATA_TWO = ROOT / "data" / "two"
IMG = ROOT / "output" / "images"
IMG.mkdir(parents=True, exist_ok=True)

CHEM = "#d4e8a0"
TRACE = "#d95f5f"
PALETTE = ["#d95f5f", "#c5d9f7", "#d9ccee", "#f9c4a8", "#a8ddd4", "#f4c2cb"]


def load_uvvis(path: Path) -> pd.DataFrame:
    """Shimadzu UV-2550 export: 2-line header then Wavelength,Abs rows."""
    df = pd.read_csv(path, skiprows=2, header=None, names=["wavelength_nm", "absorbance"])
    df = df.dropna().astype(float)
    df = df[(df["wavelength_nm"] >= 190) & (df["wavelength_nm"] <= 800)]
    return df.sort_values("wavelength_nm").reset_index(drop=True)


def load_fluoromax(path: Path) -> pd.DataFrame:
    """FluoroMax-3 export: Wavelength,S1 header, then units row, then data."""
    df = pd.read_csv(path, skiprows=2, header=None, names=["wavelength_nm", "signal"])
    return df.dropna().astype(float).reset_index(drop=True)


UVVIS_SAMPLES = {
    "S2 yellow HL (neat stock)": ("20260417_UVVis_S2_yellow_rep1.txt", (200, 600)),
    "S2 yellow HL (1 drop / 3 mL)": ("20260417_UVVis_S2_yellow_1drop.txt", (200, 600)),
    "S3 pink HL": ("20260417_UVVis_S3_pink.txt", (200, 700)),
    "S4 curcumin (EtOH)": ("20260417_UVVis_S4_curcumin.txt", (210, 600)),
    "S5 green tea (EtOH)": ("20260417_UVVis_S5_greentea.txt", (210, 750)),
    "S6 salicylate (aspirin/NaHCO3)": ("20260417_UVVis_S6_salicylate.txt", (210, 500)),
}


def find_primary_peak(df, lo, hi, min_abs=0.05):
    mask = (df.wavelength_nm >= lo) & (df.wavelength_nm <= hi)
    sub = df[mask].reset_index(drop=True)
    # Detector pins at A = 5.0 when saturated; drop those points from peak search.
    sub = sub[sub.absorbance < 4.9]
    if sub.empty:
        return None, None
    peaks, props = find_peaks(sub.absorbance.values, prominence=0.02, distance=20)
    if not len(peaks):
        i = int(sub.absorbance.idxmax())
        return float(sub.wavelength_nm.iloc[i]), float(sub.absorbance.iloc[i])
    # Report the most prominent peak in the visible/near-UV range
    idx = peaks[np.argmax(props["prominences"])]
    return float(sub.wavelength_nm.iloc[idx]), float(sub.absorbance.iloc[idx])


def plot_uvvis_overlay():
    fig, ax = plt.subplots(figsize=(9, 5))
    records = []
    for (label, (fname, (lo, hi))), color in zip(UVVIS_SAMPLES.items(), PALETTE):
        df = load_uvvis(DATA_ONE / fname)
        ax.plot(df.wavelength_nm, df.absorbance, color=color, lw=1.4, label=label)
        peak_nm, peak_a = find_primary_peak(df, lo, hi)
        records.append({"sample": label, "file": fname,
                        "lambda_max_nm": peak_nm, "A_at_peak": peak_a})
        if peak_nm is not None:
            ax.annotate(f"{peak_nm:.0f} nm",
                        xy=(peak_nm, peak_a), xytext=(peak_nm + 8, peak_a + 0.04),
                        fontsize=8, color=color)
    ax.set_xlim(200, 750)
    ax.set_ylim(-0.05, None)
    ax.set_xlabel("Wavelength (nm)")
    ax.set_ylabel("Absorbance")
    ax.set_title("UV-Vis absorption — Shimadzu UV-2550 (Session 01 pilot)")
    ax.legend(loc="upper right", fontsize=8)
    ax.grid(alpha=0.25)
    fig.tight_layout()
    fig.savefig(IMG / "uvvis_overlay.png", dpi=300)
    plt.close(fig)
    return pd.DataFrame(records)


def compute_dilution_table(peak_df):
    peak_df = peak_df.copy()
    peak_df["D = A / 0.05"] = (peak_df["A_at_peak"] / 0.05).round(1)
    peak_df["drops sample : drops solvent"] = peak_df["D = A / 0.05"].apply(
        lambda d: f"1 : {max(int(round(d)) - 1, 0)}" if d and d > 1 else "use neat"
    )
    return peak_df


def plot_fluoromax():
    em = load_fluoromax(DATA_TWO / "20260417_S2_yellow_EM_ex488.csv")
    ex = load_fluoromax(DATA_TWO / "20260417_S2_yellow_EX_em515.csv")

    fig, ax = plt.subplots(figsize=(9, 5))
    # Excitation is in microamps (reference detector); emission in CPS — normalize both to 0..1 for overlay.
    em_n = em.signal / em.signal.max()
    ex_n = ex.signal / ex.signal.max()
    ax.plot(ex.wavelength_nm, ex_n, color="#c5d9f7", lw=1.6,
            label="Excitation (em fixed at 515 nm)")
    ax.plot(em.wavelength_nm, em_n, color=TRACE, lw=1.6,
            label="Emission (ex fixed at 488 nm)")

    em_peak = em.loc[em.signal.idxmax(), "wavelength_nm"]
    ex_peak = ex.loc[ex.signal.idxmax(), "wavelength_nm"]
    ax.axvline(em_peak, color=TRACE, lw=0.7, ls="--", alpha=0.5)
    ax.axvline(ex_peak, color="#5d7fb8", lw=0.7, ls="--", alpha=0.5)
    ax.annotate(f"ex λ_max = {ex_peak:.0f} nm", (ex_peak, 1.01),
                ha="center", fontsize=9, color="#5d7fb8")
    ax.annotate(f"em λ_max = {em_peak:.0f} nm", (em_peak, 1.01),
                ha="center", fontsize=9, color=TRACE)

    stokes = em_peak - ex_peak
    ax.text(0.02, 0.95, f"Stokes shift: {stokes:.0f} nm",
            transform=ax.transAxes, fontsize=10,
            bbox=dict(facecolor="white", edgecolor="#cccccc", alpha=0.9))

    ax.set_xlabel("Wavelength (nm)")
    ax.set_ylabel("Normalized signal (0–1)")
    ax.set_title("Yellow highlighter — FluoroMax-3 excitation + emission")
    ax.legend(loc="upper right", fontsize=9)
    ax.grid(alpha=0.25)
    fig.tight_layout()
    fig.savefig(IMG / "fluoromax_yellow.png", dpi=300)
    plt.close(fig)
    return {"excitation_peak_nm": float(ex_peak),
            "emission_peak_nm": float(em_peak),
            "stokes_shift_nm": float(stokes)}


def main():
    peak_df = plot_uvvis_overlay()
    dilution_df = compute_dilution_table(peak_df)
    dilution_df.to_csv(ROOT / "output" / "uvvis_peaks.csv", index=False)
    print("UV-Vis peak table:")
    print(dilution_df.to_string(index=False))

    fluo = plot_fluoromax()
    print("\nFluoroMax-3 (yellow HL):")
    for k, v in fluo.items():
        print(f"  {k}: {v}")


if __name__ == "__main__":
    main()
