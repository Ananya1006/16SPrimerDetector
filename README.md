# Primer Detection Workflow

This pipeline is designed to detect primer sequences from amplicon sequencing files across multiple Bioprojects using simple shell scripts. It supports both Single-End and Paired-End sequencing data. The pipeline is useful for handling large datasets from multiple Bioprojects, ensuring primer consistency across datasets, detecting variations from the stated metadata, and checking for incomplete primer removal.

## Features
- Automatically scans each `.fastq.gz` file for all possible 16S rRNA primer sequences.
- Reports which primers are most abundant in each sample.
- Summarizes primer occurrence across multiple Bioprojects.
- Additionally, converts primers to IUPAC notation for flexible use in downstream bioinformatics tools.

## Input Requirements

- Bioproject directory names must start with `PRJNA` (e.g., `PRJNA1`, `PRJNA2`, etc.).
- The compressed `.fastq.gz` filenames for Paired-End data should end with:
  - `_1.fastq.gz` (forward read) 
  - `_2.fastq.gz` (reverse read) 
- For Single-End data, the files should only have one read (`.fastq.gz`).

## Pipeline Usage

### 1) Clone the repository
```
git clone <repository_url>
``` 
### 2) Navigate to the correct folder (single_end or paired_end folder)
``` 
cd single_end
or 
cd paired_end
```
### 3) Make the scripts executable
``` 
chmod +x .sh
```
### 4) Run the scripts in order
#### a) For Single-End data:
```
bash 00_singlend_primer_detect.sh
bash 01_primer_iupac.sh
```
#### b) For Paired-End data:
```
bash 00_pairend_primer_detect.sh
bash 01_primer_iupac.sh
```
## That's it! The analysis is complete.

## **Output Overview**
Inside each Bioproject folder (PRJNAx/):
   
- `primer_occurences.txt` — Number of reads matching each primer.

- `detected_primers.txt` — Most frequent primer detected per sample (primer name e.g., 341F or 515F + IUPAC regex).

- `primers_iupac.txt` — Primer sequences converted to IUPAC notation.

In the root folder (`paired_end`/ or `single_end`/):
- `summary_all_PRJNA.txt` — Summary of the highest occurring primers across all Bioprojects.




