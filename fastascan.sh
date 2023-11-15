#!/bin/bash

##You can search for fasta/fa files in the folder you want, but if no path is written, use the current folder by default(.)

if [[ -n "$1" ]]; then
	folder="$1"
else
	folder="."
fi


fa_fasta_files=$(find "$folder" -type f -name "*.fa" -o -name "*.fasta")

echo "Folder: $folder"

echo "Fasta Files: "


files_count=0
for file in $fa_fasta_files; do
    ((files_count++)); awk '/^>/{gsub(/>/, "",$1); print $1; exit}' "$file" | uniq -c
done

echo "Total number of files: $files_count"
