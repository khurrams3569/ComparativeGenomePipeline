#!/bin/bash
#SBATCH --job-name=DupClass
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=20G
#SBATCH --time=02:00:00
#SBATCH --output=logs/duplication_%j.out
#SBATCH --error=logs/duplication_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate synteny

source config/config.sh

cd results/mcscanx/output

/home/khshahza/MCScanX/duplicate_gene_classifier \
Chlorella

echo "Duplication classification finished."
