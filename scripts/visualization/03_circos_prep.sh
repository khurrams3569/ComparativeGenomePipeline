#!/bin/bash

set -e

echo "======================================"
echo " Preparing Circos input files"
echo "======================================"

PROJECT=$(pwd)

OUTDIR=${PROJECT}/results/figures/circos

mkdir -p ${OUTDIR}

COL=${PROJECT}/results/mcscanx/output/Chlorella.collinearity

echo "Reading ${COL}"

#############################################
# KARYOTYPE
#############################################

awk '
{
if($2!=""){
chr=$2
gsub("\\.t1","",chr)

if(!(chr in seen)){
seen[chr]=1
print "chr -",chr,chr,1,1000000,"grey"
}
}
}' ${PROJECT}/results/mcscanx/output/Chlorella.gff \
> ${OUTDIR}/karyotype.txt

echo "Karyotype completed"

#############################################
# LINKS
#############################################

awk '
BEGIN{FS="[ \t]+"}

/^## Alignment/{
next
}

NF>=5{

g1=$2
g2=$3

gsub("\\.t1","",g1)
gsub("\\.t1","",g2)

print g1,g1,1,2,g2,g2,1,2

}
' OFS=" " ${COL} \
> ${OUTDIR}/links.txt

echo "Links completed"

#############################################
# CHROMOSOME SIZES
#############################################

awk '
{
if($2!=""){
if($3>max[$2])
max[$2]=$3
}

END{

for(i in max)
print i,max[i]

}
' ${PROJECT}/results/mcscanx/output/Chlorella.gff \
| sort \
> ${OUTDIR}/chromosome_sizes.txt

echo "Chromosome size file completed"

#############################################
# GENE DENSITY
#############################################

awk '
{
bin=int($3/100000)

count[$2"\t"bin]++

}

END{

for(i in count){

split(i,a,"\t")

start=a[2]*100000

end=start+100000

print a[1],start,end,count[i]

}

}
' OFS="\t" ${PROJECT}/results/mcscanx/output/Chlorella.gff \
| sort -k1,1 -k2,2n \
> ${OUTDIR}/gene_density.txt

echo "Gene density completed"

#############################################
# SUMMARY
#############################################

echo
echo "Generated files"

ls -lh ${OUTDIR}

echo
echo "Circos preparation finished."
