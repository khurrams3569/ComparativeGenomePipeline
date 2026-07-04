#!/bin/bash

############################
# Comparative Genome Pipeline
# Config file (USER EDIT ONLY THIS FILE)
############################

PROJECT="Chlorella"

THREADS=64
MEMORY="250G"

# Paths
PROJECT_DIR=$PWD

DATA_DIR=$PROJECT_DIR/data
GENOME_DIR=$DATA_DIR/genomes
PROTEIN_DIR=$DATA_DIR/proteins
GFF_DIR=$DATA_DIR/gff

RESULTS_DIR=$PROJECT_DIR/results
LOGS_DIR=$PROJECT_DIR/logs

# Genomes
GENOMES=(
"utex2526"
"utex395"
"utexb3016"
)

# Files
FASTA_EXT=".fasta"
PROTEIN_EXT=".faa"
GFF_EXT=".gff3"

# Tools
MCSCANX="/home/khshahza/MCScanX/MCScanX"
BLAST_THREADS=64

echo "Config loaded for project: $PROJECT"
