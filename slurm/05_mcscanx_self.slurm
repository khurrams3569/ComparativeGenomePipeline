#!/bin/bash
#SBATCH --job-name=MCX_self
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=12:00:00
#SBATCH --output=logs/mcscanx_self_%j.out
#SBATCH --error=logs/mcscanx_self_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate synteny
source config/config.sh

mkdir -p results/mcscanx/self

for g in "${GENOMES[@]}"
do
    echo "SELF: $g"

    mkdir -p results/mcscanx/self/$g

    cat results/mcscanx/input/${g}.gff > results/mcscanx/self/$g/${g}.gff

    cp results/blast/all_vs_all/${g}_vs_${g}.blast \
       results/mcscanx/self/$g/${g}.blast

    cd results/mcscanx/self/$g

    $MCSCANX $g

    cd $SLURM_SUBMIT_DIR
done

echo "Self analyses done"
