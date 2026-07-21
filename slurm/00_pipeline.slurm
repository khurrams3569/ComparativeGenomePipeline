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

mkdir -p logs

echo "========================================="
echo " Comparative Genome Pipeline"
echo "========================================="

########################################
# MODULE 1
# BLAST DATABASE
########################################

DB_JOB=$(sbatch --parsable slurm/01_make_database.slurm)

########################################
# MODULE 2
# ALL-VS-ALL BLAST
########################################

BLAST_JOB=$(sbatch \
--parsable \
--dependency=afterok:$DB_JOB \
slurm/02_blast_all_vs_all.slurm)

########################################
# MODULE 3
# PREPARE MCScanX INPUT
########################################

PREP_JOB=$(sbatch \
--parsable \
--dependency=afterok:$BLAST_JOB \
slurm/03_prepare_mcscanx.slurm)

########################################
# MODULE 4
# COMBINED MCScanX
########################################

MCX_COMBINED=$(sbatch \
--parsable \
--dependency=afterok:$PREP_JOB \
slurm/05_mcscanx_combined.slurm)

########################################
# MODULE 5
# SELF MCScanX
########################################

MCX_SELF=$(sbatch \
--parsable \
--dependency=afterok:$MCX_COMBINED \
slurm/05_mcscanx_self.slurm)

########################################
# MODULE 5
# PAIRWISE MCScanX
########################################

MCX_PAIRWISE=$(sbatch \
--parsable \
--dependency=afterok:$MCX_SELF \
slurm/05_mcscanx_pairwise.slurm)

########################################
# MODULE 6
# VISUALIZATION
########################################

VIS_JOB=$(sbatch \
--parsable \
--dependency=afterok:$MCX_PAIRWISE \
slurm/06_visualization.slurm)

########################################
# MODULE 7
# REPORT
########################################

REPORT_JOB=$(sbatch \
--parsable \
--dependency=afterok:$VIS_JOB \
slurm/07_report.slurm)

########################################
# MODULE 8
# DOTPLOTS
########################################

DOT_JOB=$(sbatch \
--parsable \
--dependency=afterok:$REPORT_JOB \
slurm/08_publication.slurm)

echo ""
echo "Pipeline submitted successfully."
echo ""
echo "Database      : $DB_JOB"
echo "BLAST         : $BLAST_JOB"
echo "MCScan Prep   : $PREP_JOB"
echo "Combined      : $MCX_COMBINED"
echo "Self          : $MCX_SELF"
echo "Pairwise      : $MCX_PAIRWISE"
echo "Visualization : $VIS_JOB"
echo "Report        : $REPORT_JOB"
echo "Dotplots      : $DOT_JOB"
echo ""
