#!/bin/bash

source config/config.sh

echo "Checking input data..."

for g in "${GENOMES[@]}"; do
    echo "Checking $g"

    if [ ! -f "$GENOME_DIR/${g}.fasta" ]; then
        echo "ERROR: Genome missing for $g"
        exit 1
    fi

    if [ ! -f "$PROTEIN_DIR/${g}.faa" ]; then
        echo "ERROR: Protein missing for $g"
        exit 1
    fi

    if [ ! -f "$GFF_DIR/${g}.gff3" ]; then
        echo "ERROR: GFF missing for $g"
        exit 1
    fi
done

echo "All inputs OK ✔"
