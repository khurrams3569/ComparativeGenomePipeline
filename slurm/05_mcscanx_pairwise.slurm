#!/bin/bash
#SBATCH --job-name=MCX_pairwise
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=16
#SBATCH --mem=60G
#SBATCH --time=12:00:00
#SBATCH --output=logs/mcscanx_pairwise_%j.out
#SBATCH --error=logs/mcscanx_pairwise_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate synteny
source config/config.sh

mkdir -p results/mcscanx/pairwise

PAIRS=(
"utex2526 utex395"
"utex2526 utexb3016"
"utex395 utexb3016"
)

for pair in "${PAIRS[@]}"
do
    set -- $pair
    g1=$1
    g2=$2

    echo "PAIR: $g1 vs $g2"

    DIR=results/mcscanx/pairwise/${g1}_vs_${g2}
    mkdir -p $DIR

    cat results/mcscanx/input/${g1}.gff \
        results/mcscanx/input/${g2}.gff \
        > $DIR/${g1}_${g2}.gff

    cp results/blast/all_vs_all/${g1}_vs_${g2}.blast \
   $DIR/${g1}_${g2}.blast

    cd $DIR

    $MCSCANX ${g1}_${g2}

    cd $SLURM_SUBMIT_DIR
done

echo "Pairwise analyses done"
