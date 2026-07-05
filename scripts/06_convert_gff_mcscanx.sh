#!/bin/bash

source config/config.sh

mkdir -p results/mcscanx/input

echo "Converting GFF3 → MCScanX format..."

for g in "${GENOMES[@]}"; do

    gff=${GFF_DIR}/${g}.gff3

    awk -v OFS="\t" '
    $3=="gene" {
        match($9, /ID=([^;]+)/, a)
        gene=a[1]
        print gene, $1, $4
    }' $gff > results/mcscanx/input/${g}.gff

done

echo "GFF conversion done ✔"
