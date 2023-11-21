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
echo ""

##Initializing counter variables

files_count=0
total_id_count=0

## The main loop of the program is a "For" loop, which is used to count fa/fasta files and the total IDs
	# The "for" loop also includes if the files are symlink or not, it specifies the number of sequences and the length of nucleotide/aminoacid sequences. 

for file in $fa_fasta_files; do
	#A file counter	
	((files_count++))

    #Retrieving the count of unique fasta IDs for each file and aggregate them using a counter
	IDs=$(awk '/>/{print $1}' "$file" | uniq | wc -l)
	((total_id_count += $IDs))
	
	#Printing the name of each file
	
	echo "File name: $file"

	if [[ -h "$file" ]]; then
		echo "SYMLINK"
	else
		echo "NO SYMLINK"
	fi

	num_sequences=$(grep -c ">" "$file")
	echo There are "$num_sequences" sequences in the file

	#Nucleotides_seqs=$(awk '!/>/{print $0}')
	
	#Nucleotide_seqs=$(awk '!/>/{gsub(/[^ATGCUatgcuARNDCQEGHILKMFSTWYVarndcqeghilkmfstwyv]/, ""); print length }' "$file" | awk 	'{sum = sum + $1} END {print sum}')
	#Aminoacids_seqs=$(awk '!/>/{gsub(/[^ARNDCEQEGHILKMFPSTWYVarndceqeghilkfpstwyv]/, ""); print length }' 	"$file" | awk 	'{sum = sum + 	$1} END {print sum}')
	#echo "Total number of nucleotides:$Nucleotide_seqs"
	Nucleotide_seqs=$(grep -v ">" $file | grep -v [RNDQEHILKMFSWYVrndqehilkmfswyv] | sed 's/-//g' | tr -d "\n" | awk '{print length($0)}')
	Echo "Total number of nucleotides: $Nucleotide_seqs"

	Aminoacid_seqs=$(grep -v ">" $file | grep [RNDQEHILKMFSWYVrndqehilkmfswyv] | sed 's/-//g' | tr -d "\n" | awk '{print length($0)}')
	Echo "Total number of amino acids: $Aminoacid_seqs"

	echo ""
	
	if [[ "$num_lines" -eq 0 ]]; then
		continue
	elif [[ "$(cat $file | wc -l)" -le $((2 * num_lines)) ]]; then
		cat "$file"
	else
		echo "File content summary:"
		head -n "$num_lines" "$file"
		echo "..."
		tail -n "$num_lines" "$file"

	fi
	
	echo ""
	
	
done

echo ""
Echo "Total count:"
echo "Total number of files: $files_count"
echo "Total number of IDs: $total_id_count"
