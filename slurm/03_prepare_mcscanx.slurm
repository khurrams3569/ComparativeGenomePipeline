#!/bin/bash
#SBATCH --job-name=PrepareMCScanX
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=4
#SBATCH --mem=10G
#SBATCH --time=02:00:00
#SBATCH --output=logs/prepare_mcscanx_%j.out
#SBATCH --error=logs/prepare_mcscanx_%j.err

set -e

cd $SLURM_SUBMIT_DIR

source ~/miniconda3/etc/profile.d/conda.sh
conda activate synteny

source config/config.sh

mkdir -p results/mcscanx/input

for g in "${GENOMES[@]}"
do

awk '
$3=="gene"{
match($9,/ID=([^;]+)/,a)
print $1"\t"a[1]".t1\t"$4
}
' ${GFF_DIR}/${g}.gff3 \
> results/mcscanx/input/${g}.gff

done

echo "MCScanX GFF files generated successfully."
