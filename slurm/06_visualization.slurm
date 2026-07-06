#!/bin/bash
#SBATCH --job-name=Visualization
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=32G
#SBATCH --time=12:00:00
#SBATCH --output=logs/visualization_%j.out
#SBATCH --error=logs/visualization_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate vis_env

mkdir -p results/figures
mkdir -p results/figures/dotplots
mkdir -p results/figures/circos
mkdir -p results/figures/heatmaps
mkdir -p results/figures/summaries

echo "===================================="
echo "Generating figures"
echo "===================================="

##################################################
# Dotplots
##################################################

if [ -f scripts/visualization/01_dotplot.py ]; then

    for file in results/mcscanx/combined/*.collinearity \
                results/mcscanx/self/*/*.collinearity \
                results/mcscanx/pairwise/*/*.collinearity
    do

        [ -f "$file" ] || continue

        python scripts/visualization/01_dotplot.py "$file"

    done

fi

##################################################
# Circos preparation
##################################################

if [ -f scripts/visualization/03_circos_prep.sh ]; then

    bash scripts/visualization/03_circos_prep.sh

fi

echo "Visualization completed."
