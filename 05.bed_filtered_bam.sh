#bin/bash

# Author: Cameron Prybol
# Created: 2014.06.25
# Last Updated:
# Description: 

#BASE="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd | perl -pe 's|/[A-Z_]+/[A-Z_]+$||g')"
BASE="/lustre1/escratch1/cprybol1_Aug_28"
FILES="$BASE"/OR_MINUS_MV_SNPS_BAM/*

#########################################################
#	if output folder doesn't exist, make it
########################################################

if [ ! -d "$BASE/BED_FILTERED_BAM" ];
        then
                mkdir "$BASE/BED_FILTERED_BAM"
                echo "> created directory $BASE/BED_FILTERED_BAM"
fi

##############################################################
#	assign directory variable names
##############################################################

IN_DIR="$BASE/OR_MINUS_MV_SNPS_BAM"

# determine number of files, used for creating readable output to user
num_files=$(ls -1 "$IN_DIR" | wc -l)

i=1

OUT_DIR="$BASE/BED_FILTERED_BAM"

###############################################################################################################
#	
##############################################################################################################

for f in $FILES
do
        echo "> Processing file $i of $num_files" 

	#remove the path prefix on the file name
	in_file=${f##*/}
	out_file=$(echo "$in_file" | sed -e 's/\.minus_mv_snps.sorted.*/\.bed_filtered/')

	/usr/local/bedtools/latest/bin/bedtools intersect -v -abam "$f" -b "$BASE/ESSENTIAL/HETEROCHROMATIN/temp.bed" > "$OUT_DIR/$out_file.bam"

        let i=i+1

done
