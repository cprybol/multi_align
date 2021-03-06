#!/bin/bash

# run FASTQC on reads to check quality of data
cd `pwd`
BASE="$( dirname "$( dirname "$( echo `pwd` )" )" )"

FILES="$(ls "$BASE"/ESSENTIAL/FASTQ/*.R1.fastq.gz)"

OUT_DIR="$BASE/LIGHTER_FASTQ"

# if output folder does not exist, create it
if [ ! -d "$OUT_DIR" ];
        then
                mkdir "$OUT_DIR"
                echo "> created directory $OUT_DIR"
fi


# write blank file to append output data to
> "$OUT_DIR/lighter.out"

echo "$FILES"

CONFIG_FILE="$BASE/ESSENTIAL/config.txt"
cores="$( grep "^cores:" $CONFIG_FILE | perl -pe 's/cores://' )"

# run ligther on all fastq files
for f in $FILES
do

	forward_file=${f##*/}
	reverse="$( echo $f | perl -pe 's/\.R1\.fastq/\.R2\.fastq/' )"
	reverse_file=${reverse##*/}
	echo -e "running Lighter on \n\t $forward_file \t $reverse_file" >> "$OUT_DIR/lighter.out"

	# run lighter using the forward and reverse read pairs, with a k-mer size
	# of 19 (see Figure 5 of paper)
	# -K kmer_length genom_size: in this case, the genome size should be relative accurate
	# -od set out directory
	# -trim: allow trimming at ends of low-quality
	# -stable: sequentialize the sampling stage, output the same result with different runs (default: false)
	# -t num_of_threads: number of threads to use (default: 1)
	lighter -r "$f" -r "$reverse" -K 19 41020000 -od "$OUT_DIR" -trim -stable -t $cores 2>> "$OUT_DIR/lighter.out"

done
