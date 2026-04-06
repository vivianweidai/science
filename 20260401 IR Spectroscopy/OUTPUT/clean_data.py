"""
Clean raw FT-IR CSV exports into standardised per-sample files.

Input:  DATA/ONE/*.CSV and DATA/TWO/*.CSV  (headerless: wavenumber, transmittance)
Output: OUTPUT/SCRUBBED/<sample>.csv        (headers: wavenumber,transmittance,absorbance)

The Nicolet iS5 already applies background correction, so transmittance
values are already relative to the background (~100 % in non-absorbing
regions).  This script parses the scientific-notation format, adds an
absorbance column [A = -log10(T/100)], and writes clean CSVs.
"""

import os, numpy as np, pandas as pd

BASE = os.path.dirname(os.path.abspath(__file__))
PROJECT = os.path.dirname(BASE)  # 20260401 IR Spectroscopy/
SCRUBBED = os.path.join(BASE, "SCRUBBED")
os.makedirs(SCRUBBED, exist_ok=True)

# Map raw filenames → clean output names
SAMPLES = {
    "ONE": {
        "acetone.CSV":        "acetone",
        "cleaner.CSV":        "cleaner",
        "coffee.CSV":         "coffee",
        "conditioner.CSV":    "conditioner",
        "finger.CSV":         "finger",
        "isopropanol.CSV":    "isopropanol",
        "lotion.CSV":         "lotion",
        "paper.CSV":          "paper",
        "paperplasticcup.CSV":"paper_plastic_cup",
        "plastic bag.CSV":    "plastic_bag",
        "plastic cap.CSV":    "plastic_cap",
        "plastic glove.CSV":  "plastic_glove",
        "salt.CSV":           "salt",
        "shampoo.CSV":        "shampoo",
        "soap.CSV":           "soap",
        "sugar.CSV":          "sugar",
        "sunscreen.CSV":      "sunscreen",
        "water.CSV":          "water",
    },
    "TWO": {
        "leaf.CSV":            "leaf",
        "orangepeel.CSV":      "orange_peel",
        "paper.CSV":           "paper_2",
        "plasticwrapper.CSV":  "plastic_wrapper",
        "plasticwrapper2.CSV": "plastic_wrapper_2",
    },
}

count = 0
for run, files in SAMPLES.items():
    for raw_name, clean_name in files.items():
        path = os.path.join(PROJECT, "DATA", run, raw_name)
        df = pd.read_csv(path, header=None, names=["wavenumber", "transmittance"])
        # Transmittance is already in percent; convert to absorbance
        # Clip to avoid log(0) — any T <= 0 gets a floor of 0.001 %
        t_clipped = df["transmittance"].clip(lower=0.001)
        df["absorbance"] = -np.log10(t_clipped / 100.0)
        out = os.path.join(SCRUBBED, f"{clean_name}.csv")
        df.to_csv(out, index=False, float_format="%.6f")
        count += 1

print(f"Wrote {count} cleaned CSVs to {SCRUBBED}")
