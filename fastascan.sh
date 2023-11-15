#!/bin/bash


#First argument: You can search for fasta/fa files in the folder you want, but if no path is written, use the current folder by default(.)

if [[ -n "$1" ]]; then
	folder="$1"
else
	folder="."
fi
#Second argument: a number of lines N (by default: 0)

if [[ -n "$2" ]]; then
	num_lines="$2"
else
	num_lines="0"
fi

#Searching the fa/fasta files

fa_fasta_files=$(find "$folder" -type f -name "*.fa" -o -name "*.fasta")

echo "Folder: $folder"

echo "Fa/fasta IDs: "


files_count=0
total_id_count=0

for file in $fa_fasta_files; do
	if [[ $(wc -l < "$file") -ge $num_lines ]]; then

    	((files_count++)); IDs=$(awk '/^>/{gsub(/>/, "",$1); print $1; exit}' "$file" | uniq -c)
	echo "$IDs"
	Id_count=0
	for Id in $IDs; do
		((Id_count++))		
	done
	((total_id_count += Id_count))

	fi
done

echo "Total number of files: $files_count"
echo "Total number of IDs: $total_id_count"
