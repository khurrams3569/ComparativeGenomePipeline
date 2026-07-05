#!/bin/bash

source config/config.sh

mkdir -p results/figures/circos

echo -e "chr1 start end chr2 start end" > results/figures/circos/circos_links.txt

for file in results/mcscanx/output/*.collinearity; do
    grep -v "#" $file >> results/figures/circos/circos_links.txt
done

echo "Circos input prepared ✔"
