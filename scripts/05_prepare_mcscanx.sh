#!/bin/bash

source config/config.sh

mkdir -p results/mcscanx

echo "Preparing MCScanX input..."

for file in results/blast/pairwise/*.blast; do
    name=$(basename $file .blast)

    awk '{print $1"\t"$2"\t"$11"\t"$12}' $file \
        > results/mcscanx/${name}.mcscan

done

echo "MCScanX input ready ✔"
