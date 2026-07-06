#!/bin/bash
#SBATCH --job-name=Publication
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --output=logs/publication_%j.out
#SBATCH --error=logs/publication_%j.err

set -e

cd $SLURM_SUBMIT_DIR

mkdir -p results/publication

echo "Collecting publication files"

##################################################

cp -r results/figures \
      results/publication/

cp -r results/tables \
      results/publication/

cp -r results/reports \
      results/publication/

cp -r results/mcscanx \
      results/publication/

##################################################

find results/publication > results/publication/Publication_File_List.txt

echo "Publication package created."1~#!/bin/bash
#SBATCH --job-name=Publication
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=8G
#SBATCH --time=02:00:00
#SBATCH --output=logs/publication_%j.out
#SBATCH --error=logs/publication_%j.err

set -e

cd $SLURM_SUBMIT_DIR

mkdir -p results/publication

echo "Collecting publication files"

##################################################

cp -r results/figures \
      results/publication/

cp -r results/tables \
      results/publication/

cp -r results/reports \
      results/publication/

cp -r results/mcscanx \
      results/publication/

##################################################

find results/publication > results/publication/Publication_File_List.txt

echo "Publication package created."
