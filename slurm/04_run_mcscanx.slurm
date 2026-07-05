#!/bin/bash
#SBATCH --job-name=MCScanX
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=12:00:00
#SBATCH --output=logs/mcscanx_%j.out
#SBATCH --error=logs/mcscanx_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate synteny

source config/config.sh

mkdir -p results/mcscanx/output

############################################
# Combine GFF files
############################################

cat results/mcscanx/input/*.gff \
> results/mcscanx/output/Chlorella.gff

############################################
# Combine BLAST files
############################################

cat results/blast/all_vs_all/*.blast \
> results/mcscanx/output/Chlorella.blast

############################################
# Run MCScanX
############################################

cd results/mcscanx/output

$MCSCANX Chlorella

echo "MCScanX completed."
