#!/bin/bash
#SBATCH --job-name=ChlorellaPipeline
#SBATCH --partition=nocona
#SBATCH --nodes=1
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=2
#SBATCH --mem=4G
#SBATCH --time=01:00:00
#SBATCH --output=logs/pipeline_%j.out
#SBATCH --error=logs/pipeline_%j.err

set -e

cd $SLURM_SUBMIT_DIR

echo "Submitting jobs..."


DB_JOB=$(sbatch --parsable slurm/01_make_database.slurm)

BLAST_JOB=$(sbatch --dependency=afterok:$DB_JOB --parsable \
slurm/02_blast_all_vs_all.slurm)

PREP_JOB=$(sbatch --dependency=afterok:$BLAST_JOB --parsable \
slurm/03_prepare_mcscanx.slurm)

MCSCAN_JOB=$(sbatch --dependency=afterok:$PREP_JOB --parsable \
slurm/04_run_mcscanx.slurm)

DUP_JOB=$(sbatch --dependency=afterok:$MCSCAN_JOB --parsable \
slurm/05_duplication.slurm)

echo "Pipeline submitted successfully."

echo "Database Job : $DB_JOB"
echo "BLAST Job    : $BLAST_JOB"
