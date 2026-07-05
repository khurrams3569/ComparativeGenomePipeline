#!/bin/bash
#SBATCH --job-name=vis_pipeline
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
#SBATCH --time=48:00:00
#SBATCH --partition=nocona
#SBATCH --output=logs/visualization/master_%j.out

echo "Starting visualization pipeline..."

sbatch slurm/visualization/01_dotplot.slurm

bash scripts/visualization/02_summary.py

bash scripts/visualization/03_circos_prep.sh

echo "Visualization pipeline submitted ✔"
