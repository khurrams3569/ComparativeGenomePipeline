#!/bin/bash
#SBATCH --job-name=mcscanx
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=64
#SBATCH --mem=128G
#SBATCH --time=48:00:00
#SBATCH --partition=nocona
#SBATCH --output=logs/mcscanx/mcscanx_%j.out
#SBATCH --error=logs/mcscanx/mcscanx_%j.err

source config/config.sh

module load mcscanx 2>/dev/null || true

echo "Running MCScanX engine..."

mkdir -p results/mcscanx/output

########################################
# STEP 1: SELF ANALYSIS
########################################

for g in "${GENOMES[@]}"; do

    echo "SELF synteny: $g"

    cp results/mcscanx/input/${g}.gff results/mcscanx/input.txt
    cp results/blast/pairwise/${g}_vs_${g}.blast results/mcscanx/input.blast

    cd results/mcscanx

    $MCSCANX input.txt input.blast

    mv *.collinearity output/${g}_self.collinearity

    cd ../..

done

########################################
# STEP 2: PAIRWISE ANALYSIS
########################################

PAIRS=(
"utex2526 utex395"
"utex2526 utexb3016"
"utex395 utexb3016"
)

for pair in "${PAIRS[@]}"; do

    set -- $pair
    g1=$1
    g2=$2

    echo "PAIRWISE: $g1 vs $g2"

    cat results/mcscanx/input/${g1}.gff results/mcscanx/input/${g2}.gff \
        > results/mcscanx/input.txt

    cp results/blast/pairwise/${g1}_vs_${g2}.blast results/mcscanx/input.blast

    cd results/mcscanx

    $MCSCANX input.txt input.blast

    mv *.collinearity output/${g1}_vs_${g2}.collinearity

    cd ../..

done

echo "MCScanX completed ✔"
