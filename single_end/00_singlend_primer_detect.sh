#!/bin/bash

# Color codes for terminal output
CYAN="\033[1;36m"
RESET="\033[0m"

# Read primers from a FASTA file into an associative array
declare -A PRIMERS
while read -r line; do
    if [[ $line == ">"* ]]; then
        primer_name=${line#>}  # Remove '>' character
    else
        PRIMERS["$primer_name"]=$line
    fi
done < ./primers.fa

# Create overall summary file
summary_all="summary_all_PRJNA.txt"
echo -e "${CYAN}Highest Occurring Primers Across PRJNA Datasets (Single-End)${RESET}"
echo "Highest Occurring Primers Across PRJNA Datasets (Single-End)" > "$summary_all"
echo "===========================================================" >> "$summary_all"

# Loop through each PRJNA directory
for dir in PRJNA*; do
    if [[ -d $dir ]]; then
        echo -e "${CYAN}Processing directory: $dir${RESET}"

        output_file="${dir}/primer_occurrences.txt"
        summary_file="${dir}/detected_primers.txt"

        # Write headers to output files
        echo "Primer Detection Results (Single-End)" > "$output_file"
        echo "=====================================" >> "$output_file"
        echo "Detected Primer Summary (Single-End)" > "$summary_file"
        echo "====================================" >> "$summary_file"

        # Initialize highest primer tracking variables
        highest_count_overall=0
        highest_primer_overall=""
        highest_primer_seq_overall=""

        # Loop through each FASTQ.gz file in the directory
        for file in "$dir"/*.fastq.gz; do
            echo "Processing file: $file"
            echo -e "\n$file" >> "$output_file"
            echo "$file" >> "$summary_file"

            highest_count=0
            highest_primer=""
            highest_primer_seq=""

            # Check each primer
            for primer_name in "${!PRIMERS[@]}"; do
                primer_seq="${PRIMERS[$primer_name]}"

                # Count the occurrences of the primer in the FASTQ file
                count=$(zgrep -E -i "$primer_seq" "$file" | wc -l)

                echo "$primer_name: $count occurrences" >> "$output_file"

                # Track the highest for this file
                if [[ $count -gt $highest_count ]]; then
                    highest_count=$count
                    highest_primer=$primer_name
                    highest_primer_seq=$primer_seq
                fi
            done

            # Update project-wide stats
            if [[ $highest_count -gt $highest_count_overall ]]; then
                highest_count_overall=$highest_count
                highest_primer_overall=$highest_primer
                highest_primer_seq_overall=$highest_primer_seq
            fi

            # Record the most abundant primer for this file
            echo "Highest occurrence: $highest_primer ($highest_count occurrences)" >> "$output_file"
            echo "Primer sequence: $highest_primer_seq" >> "$output_file"
            echo "-------------------------------------" >> "$output_file"

            echo "Highest occurrence: $highest_primer ($highest_count occurrences)" >> "$summary_file"
            echo "Primer sequence: $highest_primer_seq" >> "$summary_file"
            echo "-------------------------------------" >> "$summary_file"
        done

        # Write final summary for this PRJNA project
        echo -e "\n$dir:" >> "$summary_all"
        if [[ -z $highest_primer_overall ]]; then
            echo "No primers detected." >> "$summary_all"
        else
            echo "Highest occurring primer (Single-End Reads): $highest_primer_overall ($highest_count_overall occurrences)" >> "$summary_all"
        fi

        echo "Detection results saved in $output_file"
        echo "Summary of highest occurrence primers saved in $summary_file"
    fi
done

echo -e "${CYAN}All PRJNA directories processed.${RESET}"
echo -e "${CYAN}Final summary written to: $summary_all${RESET}"

