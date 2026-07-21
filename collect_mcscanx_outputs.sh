#!/bin/bash

PROJECT_DIR=/lustre/scratch/khshahza/syntany_analysis
OUTDIR=$PROJECT_DIR/results/report/input_data

mkdir -p $OUTDIR

# Copy MCScanX outputs
cp $PROJECT_DIR/results/synteny/*.collinearity $OUTDIR/
cp $PROJECT_DIR/results/synteny/*.gff $OUTDIR/

# Copy BLAST results
cp $PROJECT_DIR/results/blast/all_vs_all/*.blast $OUTDIR/

# Copy figures
cp $PROJECT_DIR/results/figures/* $OUTDIR/

# Copy stats if available
cp $PROJECT_DIR/results/stats/*.txt $OUTDIR/ 2>/dev/null
