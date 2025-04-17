#!/bin/bash

# Color codes for terminal output
CYAN="\033[1;36m"
RESET="\033[0m"

echo -e "${CYAN}Converting primers from the standard nucleotide alphabets to IUPAC nucleotide code${RESET}"

# Define IUPAC conversion mapping
declare -A IUPAC_MAP=(
    ["A"]="A" ["C"]="C" ["G"]="G" ["T"]="T"
    ["AC"]="M" ["AG"]="R" ["AT"]="W" ["CG"]="S"
    ["CT"]="Y" ["GT"]="K" ["ACG"]="V" ["ACT"]="H"
    ["AGT"]="D" ["CGT"]="B" ["ACGT"]="N"
)

# Function to convert primer sequence
convert_primer() {
    local primer="$1"
    # Replace bracketed sequences with corresponding IUPAC code
    while [[ "$primer" =~ \[([ACGT]+)\] ]]; do
        match="${BASH_REMATCH[1]}"
        replacement="${IUPAC_MAP[$match]}"
        primer="${primer/\[${match}\]/$replacement}"
    done
    echo "$primer"
}

# Process each PRJNA directory
for prj_folder in PRJNA*; do
    [[ -d "$prj_folder" && -f "$prj_folder/detected_primers.txt" ]] || continue
    echo "Processing $prj_folder..."
    
    output_file="$prj_folder/primers_iupac.txt"
    echo "Converted Primer Summary" > "$output_file"
    echo "========================" >> "$output_file"

    while IFS= read -r line; do
        if [[ "$line" =~ Primer\ sequence:\ (.*) ]]; then
            converted_seq=$(convert_primer "${BASH_REMATCH[1]}")
            echo "Primer sequence: $converted_seq" >> "$output_file"
        else
            echo "$line" >> "$output_file"
        fi
    done < "$prj_folder/detected_primers.txt"

    echo "Converted file saved to $output_file"
done

echo -e "${CYAN}Done${RESET}!"
