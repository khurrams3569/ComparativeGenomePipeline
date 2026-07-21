#!/usr/bin/env python3

import os
import re
import numpy as np
import pandas as pd
import matplotlib.pyplot as plt
from matplotlib.colors import LinearSegmentedColormap

# ----------------------------------------------------
# Settings
# ----------------------------------------------------

PROJECT = os.getcwd()

COLLINEARITY = os.path.join(
    PROJECT,
    "results",
    "mcscanx",
    "output",
    "Chlorella.collinearity"
)

OUTDIR = os.path.join(
    PROJECT,
    "results",
    "figures",
    "summaries"
)

os.makedirs(OUTDIR, exist_ok=True)

GENOMES = [
    "utex2526",
    "utex395",
    "utexb3016"
]

# ----------------------------------------------------
# Matrix
# ----------------------------------------------------

matrix = pd.DataFrame(
    0,
    index=GENOMES,
    columns=GENOMES,
    dtype=int
)
# ----------------------------------------------------
# Read MCScanX collinearity file
# ----------------------------------------------------

print("Reading MCScanX collinearity file...")

current_pair = None

with open(COLLINEARITY) as infile:

    for line in infile:

        line = line.strip()

        if not line:
            continue

        # New alignment block
        if line.startswith("## Alignment"):

            m = re.search(r'([A-Za-z0-9_]+)&([A-Za-z0-9_]+)', line)

            if m:

                chr1 = m.group(1)
                chr2 = m.group(2)

                g1 = None
                g2 = None

                for genome in GENOMES:

                    if chr1.startswith(genome):
                        g1 = genome

                    if chr2.startswith(genome):
                        g2 = genome

                current_pair = (g1, g2)

            continue

        # Skip comments
        if line.startswith("#"):
            continue

        if current_pair is None:
            continue

        fields = line.split()

        if len(fields) < 3:
            continue

        g1, g2 = current_pair

        if g1 is None or g2 is None:
            continue

        matrix.loc[g1, g2] += 1

# ----------------------------------------------------
# Make matrix symmetric
# ----------------------------------------------------

for i in GENOMES:
    for j in GENOMES:

        if i != j:

            value = max(matrix.loc[i, j], matrix.loc[j, i])

            matrix.loc[i, j] = value
            matrix.loc[j, i] = value

print()
print(matrix)
print()
