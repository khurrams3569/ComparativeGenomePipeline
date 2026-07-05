#!/bin/bash
#SBATCH --job-name=MakeDB
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=8
#SBATCH --mem=20G
#SBATCH --time=04:00:00
#SBATCH --output=logs/makedb_%j.out
#SBATCH --error=logs/makedb_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate synteny

source config/config.sh

mkdir -p results/blast/db

for g in "${GENOMES[@]}"
do
    echo "Creating database for $g"

    makeblastdb \
        -in ${PROTEIN_DIR}/${g}.faa \
        -dbtype prot \
        -out results/blast/db/${g}
done

echo "Finished."
