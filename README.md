# 16S Primer Miner

This pipeline is designed to detect primer sequences from amplicon sequencing files across multiple Bioprojects using simple shell scripts. Supports both **Single-End** and **Paired-End** sequencing data. It can be useful for handling large datasets from multiple Bioprojects, ensuring primer consistency across datasets or detecting variations from the stated metadata, and checking for incomplete primer removal.

The pipeline:
1) Automatically scans each .fastq.gz file for all possible 16S rRNA primer sequences.
2) Reports which primers are most abundant in each sample.
3) Summarizes primer occurrence across an multiple BioProjects.
4) Converts primers to IUPAC notation for flexible use in downstream bioinformatics tools.

Input Requirements
1) Bioproject directories must start with PRJNA (e.g., PRJNA1, PRJNA2 and so on).
2) The compressed fastq.gz filenames should end with "_1.fastq.gz" (forward read) and "_2.fastq.gz" (reverse read) for paired end data.
  
Pipeline Usage 

1) Navigate to the correct folder:
cd paired_end or cd single_end

2) Make scripts executable:
chmod +x *.sh

3) Run the pipeline scripts in order:

For Single-End data:
bash 00_singlend_primer_detect.sh
bash 01_primer_iupac.sh

For Paired-End data:
bash 00_pairend_primer_detect.sh
bash 01_primer_iupac.sh

That’s it! 

Output Overview

1) Inside each Bioproject folder (PRJNAxxxx/):
primer_occurences.txt — Number of reads matching each primer.
detected_primers.txt — Most frequent primer detected per SRA sample (name + IUPAC regex).
primers_iupac.txt — Primer sequences converted to IUPAC notation.

In the root folder (paired_end/ or single_end/):
summary_all_PRJNA.txt — Summary of the highest occuring primers across all Bioprojects.

