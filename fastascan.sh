#!/bin/bash

if [[ -n "$1" ]]; then
	folder="$1"
else
	folder="."
fi


fa_fasta_files=$(find "$folder" -type f -name "*.fa" -o -name "*.fasta")

echo "Folder: $folder"

echo "Fasta Files: "


for file in $fa_fasta_files; do
    echo "$file" 
done