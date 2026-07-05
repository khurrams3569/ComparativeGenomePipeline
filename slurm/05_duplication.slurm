#!/bin/bash
#SBATCH --job-name=mcscanx_dup
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
#SBATCH --time=48:00:00
#SBATCH --partition=nocona
#SBATCH --output=logs/mcscanx/dup_%j.out

source config/config.sh

module load mcscanx 2>/dev/null || true

echo "Running duplication analysis..."

cd results/mcscanx/output

for file in *.collinearity; do

    base=$(basename $file .collinearity)

    $MCSCANX $base

done

echo "Duplication analysis done ✔"
