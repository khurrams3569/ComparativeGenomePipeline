#!/bin/bash
#SBATCH --job-name=AllBLAST
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=120G
#SBATCH --time=48:00:00
#SBATCH --output=logs/blast_%j.out
#SBATCH --error=logs/blast_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate synteny

source config/config.sh

mkdir -p results/blast/all_vs_all

for q in "${GENOMES[@]}"
do
    for s in "${GENOMES[@]}"
    do

        echo "$q vs $s"

        blastp \
            -query ${PROTEIN_DIR}/${q}.faa \
            -db results/blast/db/${s} \
            -out results/blast/all_vs_all/${q}_vs_${s}.blast \
            -evalue 1e-5 \
            -outfmt 6 \
            -num_threads $BLAST_THREADS

    done
done

echo "BLAST completed."
