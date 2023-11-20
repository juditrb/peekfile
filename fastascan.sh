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

#####REPORT#####

##Finding the fa/fasta files

fa_fasta_files=$(find "$folder" -type f -name "*.fa" -o -name "*.fasta")

echo "Folder: $folder"

#echo "Fa/fasta IDs of each file: "

##Initializing counter variables

files_count=0
total_id_count=0

## "For" loop to count the files, to print the files IDs and to count the total IDs
	# The "for" loop also includes if the files are symlink or not, it specifies the number of sequences and the length of nucleotide/aminoacid sequences. 

for file in $fa_fasta_files; do
	
	echo "$file"

	if [[ $(wc -l < "$file") -ge $num_lines ]]; then
    	((files_count++))

	IDs=$(awk '/^>/{gsub(/>/,  "",$1); print $1}' "$file" | uniq -c)
	#echo "$IDs"

	Id_count=0
	for Id in $IDs; do
		((Id_count++))		
	done
	((total_id_count += Id_count))

	fi
	
	if [[ -h "$file" ]]; then
		echo "SYMLINK"
	else
		echo "NO SYMLINK"
	fi

	num_sequences=$(grep -c '^>' "$file")
	echo There are "$num_sequences" sequences in the file

	
	Nucleotides_seqs=$(awk '!/>/{gsub(/[^AGTCUagtcu]/, ""); print length }' "$file" | 	awk '{sum = sum + $1} END {print sum}')

	Aminoacids_seqs=$(awk '!/>/{gsub(/[^ARNDCEQEGHILKMFPSTWYVarndceqeghilkfpstwyv]/, ""); print length }' 	"$file" | awk 	'{sum = sum + 	$1} END {print sum}')
	
	echo Total number of nucleotides: "$Nucleotides_seqs"
	echo Total number of aminoacids: "$Aminoacids_seqs"

	echo ""
	
	if [[ "$num_lines" -eq 0 ]]; then
		continue
	elif [[ "$(wc -l < "$file")" -le $((2 * num_lines)) ]]; then
		cat "$file"
	else
		head -n "$num_lines" "$file"
		echo "..."
		tail -n "$num_lines" "$file"

	fi
	
	echo ""
	
	
done

echo "Total number of files: $files_count"
echo "Total number of IDs: $total_id_count"
