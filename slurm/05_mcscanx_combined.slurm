#!/bin/bash
#SBATCH --job-name=MCX_combined
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=12:00:00
#SBATCH --output=logs/mcscanx_combined_%j.out
#SBATCH --error=logs/mcscanx_combined_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate synteny
source config/config.sh

mkdir -p results/mcscanx/combined

cat results/mcscanx/input/*.gff > results/mcscanx/combined/combined.gff
cat results/blast/all_vs_all/*.blast > results/mcscanx/combined/combined.blast

cd results/mcscanx/combined

$MCSCANX combined

echo "Combined analysis done"
