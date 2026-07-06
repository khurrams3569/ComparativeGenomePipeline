#!/bin/bash
#SBATCH --job-name=Report
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=16G
#SBATCH --time=04:00:00
#SBATCH --output=logs/report_%j.out
#SBATCH --error=logs/report_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate vis_env

mkdir -p results/reports
mkdir -p results/tables

echo "Generating reports"

python generate_summary.py

echo "Finished summary generation"

cp -r results/figures results/reports/

echo "Report complete."
