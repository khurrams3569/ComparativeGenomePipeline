#!/usr/bin/env python3

"""
===========================================================
Comparative Genome Pipeline
Module 6
Publication-quality MCScanX Dotplot Generator

Author:
Khurram Shahzad

Description
-----------
Generate publication-quality synteny dotplots directly
from MCScanX output.

Supported analyses

✓ Combined genomes
✓ Pairwise genomes
✓ Self comparisons

Outputs

PNG
PDF
SVG

Resolution

600 dpi

===========================================================
"""

import os
import re
import sys
import math
import argparse
import logging
from pathlib import Path
from collections import defaultdict, OrderedDict

import numpy as np
import pandas as pd

import matplotlib

matplotlib.use("Agg")

import matplotlib.pyplot as plt

from matplotlib.lines import Line2D

################################################################################
# Logging
################################################################################

logging.basicConfig(
    level=logging.INFO,
    format="%(asctime)s %(levelname)s : %(message)s",
)

logger = logging.getLogger(__name__)

################################################################################
# Nature-like color palette
################################################################################

GENOME_COLORS = OrderedDict({

    "utex2526": "#1f77b4",

    "utex395": "#ff7f0e",

    "utexb3016": "#2ca02c",

})

BACKGROUND = "white"

GRID = "#d9d9d9"

POINT = "#1f1f1f"

################################################################################
# Figure parameters
################################################################################

plt.rcParams["figure.figsize"] = (10,10)

plt.rcParams["figure.dpi"] = 600

plt.rcParams["savefig.dpi"] = 600

plt.rcParams["font.family"] = "DejaVu Sans"

plt.rcParams["font.size"] = 10

plt.rcParams["axes.linewidth"] = 1.2

plt.rcParams["axes.labelsize"] = 12

plt.rcParams["axes.titlesize"] = 15

plt.rcParams["xtick.labelsize"] = 9

plt.rcParams["ytick.labelsize"] = 9

plt.rcParams["legend.fontsize"] = 9

################################################################################
# Utilities
################################################################################

def mkdir(directory):

    Path(directory).mkdir(
        parents=True,
        exist_ok=True
    )


def save_all_formats(fig, outfile):

    fig.savefig(outfile + ".png",
                dpi=600,
                bbox_inches="tight")

    fig.savefig(outfile + ".pdf",
                bbox_inches="tight")

    fig.savefig(outfile + ".svg",
                bbox_inches="tight")


################################################################################
# Read MCScanX GFF
################################################################################

def read_gff(gff_file):

    logger.info("Reading GFF")

    genes = {}

    scaffold_gene_count = defaultdict(int)

    scaffold_positions = defaultdict(list)

    with open(gff_file) as fh:

        for line in fh:

            line=line.strip()

            if line=="":
                continue

            cols=line.split()

            if len(cols)<3:
                continue

            scaffold=cols[0]

            gene=cols[1]

            pos=int(cols[2])

            genes[gene]=(scaffold,pos)

            scaffold_gene_count[scaffold]+=1

            scaffold_positions[scaffold].append(pos)

    logger.info("Genes loaded : %d",len(genes))

    return genes,scaffold_gene_count,scaffold_positions

################################################################################
# Sort scaffolds
################################################################################

def sort_scaffolds(scaffold_positions):

    scaffold_length={}

    for s,positions in scaffold_positions.items():

        scaffold_length[s]=max(positions)

    ordered=sorted(

        scaffold_length.items(),

        key=lambda x:x[1],

        reverse=True

    )

    return ordered

################################################################################
# Build cumulative coordinates
################################################################################

def build_offsets(scaffold_positions):

    ordered=sort_scaffolds(scaffold_positions)

    offsets={}

    labels=[]

    ticks=[]

    cumulative=0

    gap=50000

    for scaffold,length in ordered:

        offsets[scaffold]=cumulative

        labels.append(scaffold)

        ticks.append(cumulative+length/2)

        cumulative+=length+gap

    return offsets,labels,ticks

################################################################################
# Read MCScanX collinearity
################################################################################

def read_collinearity(col_file):

    logger.info("Reading collinearity")

    links=[]

    with open(col_file) as fh:

        for line in fh:

            line=line.strip()

            if line=="":
                continue

            if line.startswith("#"):
                continue

            cols=line.split()

            if len(cols)<3:
                continue

            try:

                gene1=cols[1]

                gene2=cols[2]

            except:

                continue

            links.append((gene1,gene2))

    logger.info("Links : %d",len(links))

    return links

################################################################################
# Statistics
################################################################################

def summary_statistics(genes,links):

    stats={}

    stats["Genes"]=len(genes)

    stats["Links"]=len(links)

    stats["Scaffolds"]=len(
        set(
            x[0] for x in genes.values()
        )
    )

    return stats
################################################################################
# Convert gene pairs to plotting coordinates
################################################################################

def build_plot_data(genes, links, offsets):

    logger.info("Building plotting coordinates")

    xs = []
    ys = []
    colors = []

    for gene1, gene2 in links:

        if gene1 not in genes:
            continue

        if gene2 not in genes:
            continue

        scaffold1, pos1 = genes[gene1]
        scaffold2, pos2 = genes[gene2]

        x = offsets[scaffold1] + pos1
        y = offsets[scaffold2] + pos2

        xs.append(x)
        ys.append(y)

        genome = gene1.split("_")[0]

        colors.append(
            GENOME_COLORS.get(genome, POINT)
        )

    logger.info("Points : %d", len(xs))

    return xs, ys, colors


################################################################################
# Draw scaffold boundaries
################################################################################

def draw_scaffold_grid(ax,
                       scaffold_positions,
                       offsets):

    ordered = sort_scaffolds(scaffold_positions)

    for scaffold, length in ordered:

        start = offsets[scaffold]
        end = start + length

        ax.axvline(
            end,
            color=GRID,
            lw=0.5,
            alpha=0.6,
            zorder=0
        )

        ax.axhline(
            end,
            color=GRID,
            lw=0.5,
            alpha=0.6,
            zorder=0
        )


################################################################################
# Draw legend
################################################################################

def make_legend():

    handles = []

    for genome, color in GENOME_COLORS.items():

        handles.append(

            Line2D(

                [0],
                [0],

                marker="o",

                linestyle="",

                markersize=8,

                markerfacecolor=color,

                markeredgecolor="black",

                label=genome

            )

        )

    return handles


################################################################################
# Main plotting function
################################################################################

def draw_dotplot(

        genes,
        links,
        scaffold_positions,
        outfile,
        title

):

    logger.info("Generating dotplot")

    offsets, labels, ticks = build_offsets(
        scaffold_positions
    )

    xs, ys, colors = build_plot_data(
        genes,
        links,
        offsets
    )

    fig = plt.figure(
        figsize=(12, 12)
    )

    ax = plt.gca()

    ax.set_facecolor(BACKGROUND)

    draw_scaffold_grid(
        ax,
        scaffold_positions,
        offsets
    )

    ax.scatter(

        xs,

        ys,

        c=colors,

        s=4,

        alpha=0.55,

        linewidth=0,

        rasterized=True

    )

    ax.set_xticks(ticks)
    ax.set_xticklabels(
        labels,
        rotation=90
    )

    ax.set_yticks(ticks)
    ax.set_yticklabels(labels)

    ax.set_xlabel("Genomic position")

    ax.set_ylabel("Genomic position")

    ax.set_title(
        title,
        fontsize=16,
        weight="bold"
    )

    ax.legend(

        handles=make_legend(),

        frameon=False,

        loc="upper right"

    )

    ax.grid(False)

    plt.tight_layout()

    save_all_formats(
        fig,
        outfile
    )

    plt.close(fig)

    logger.info("Figure saved")
###############################################################################
# MAIN
###############################################################################

def main():

    if len(sys.argv) != 2:
        print("Usage:")
        print("python 01_dotplot.py Chlorella.collinearity")
        sys.exit(1)

    infile = sys.argv[1]

    if not os.path.isfile(infile):
        print("Input file not found.")
        sys.exit(1)

    outdir = "../../results/figures/dotplots"
    os.makedirs(outdir, exist_ok=True)

    print("Reading MCScanX collinearity file...")

    data = read_collinearity(infile)

    if len(data) == 0:
        print("No alignments found.")
        sys.exit(0)

    df = pd.DataFrame(data, columns=["Chr1","Chr2"])

    summary = (
        df.groupby(["Chr1","Chr2"])
          .size()
          .reset_index(name="Blocks")
          .sort_values("Blocks", ascending=False)
    )

    csv_file = os.path.join(outdir, "Dotplot_summary.csv")
    summary.to_csv(csv_file, index=False)

    print(summary.head())

    labels = [
        f"{a}\nvs\n{b}"
        for a,b in zip(summary["Chr1"],summary["Chr2"])
    ]

    values = summary["Blocks"].tolist()

    plt.figure(figsize=(14,7))

    bars = plt.bar(
        range(len(values)),
        values,
        edgecolor="black",
        linewidth=0.6
    )

    cmap = plt.cm.tab20

    for i,b in enumerate(bars):
        b.set_color(cmap(i % 20))

    plt.xticks(
        range(len(labels)),
        labels,
        rotation=90,
        fontsize=8
    )

    plt.ylabel(
        "Number of syntenic blocks",
        fontsize=13,
        fontweight="bold"
    )

    plt.xlabel(
        "Chromosome pairs",
        fontsize=13,
        fontweight="bold"
    )

    plt.title(
        "MCScanX Synteny Blocks",
        fontsize=15,
        fontweight="bold"
    )

    plt.grid(
        axis="y",
        alpha=0.35
    )

    plt.tight_layout()

    png = os.path.join(outdir,"MCScanX_Synteny_Blocks.png")
    pdf = os.path.join(outdir,"MCScanX_Synteny_Blocks.pdf")

    plt.savefig(
        png,
        dpi=600,
        bbox_inches="tight"
    )

    plt.savefig(
        pdf,
        bbox_inches="tight"
    )

    plt.close()

    print()
    print("Figure saved:")
    print(png)
    print(pdf)
    print(csv_file)


if __name__ == "__main__":
    main()
