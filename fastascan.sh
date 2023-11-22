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

	#To make sure the file is not binary, grep is used to know if the file has ">" symbol
	if [[ grep -q ">" "$file" ]]; then

		#Printing the name of each file
	
		echo "File name: $file"

		#An "if" is used to know if the file is a symlink or not, printing this information in the output
		if [[ -h "$file" ]]; then
			echo "SYMLINK"
		else
			echo "NO SYMLINK"
		fi

		#As each sequence is preceded by its ">ID", grep is used to search for the ">" symbol into the file, counting the total sequences that are there. 
		num_sequences=$(grep -c ">" "$file")
		echo There are "$num_sequences" sequences in the file

		#Counting nucleotides and amino acids depending on whether the sequence contains or does not contain the letters of the amino acids, which are RNDQEHILKMFSWYVrndqehilkmfswyv. 
			#Amino acid letters matching the nucleotides letters (AGCTUagctu) are extracted from the pattern.  

			#Nucleotide_seqs=$(grep -v ">" $file | grep -v [RNDQEHILKMFSWYVrndqehilkmfswyv] | sed 's/-//g' | tr -d "\n" | awk '{print length($0)}')
			#Echo "Total number of nucleotides: $Nucleotide_seqs"

			#Aminoacid_seqs=$(grep -v ">" $file | grep [RNDQEHILKMFSWYVrndqehilkmfswyv] | sed 's/-//g' | tr -d "\n" | awk '{print length($0)}')
			#Echo "Total number of amino acids: $Aminoacid_seqs"

		if grep -v ">" "$file" | grep -q '[RNDQEHILKMFSWYVrndqehilkmfswyv]'; then
			Aminoacid_seqs=$(grep -v ">" "$file" | sed 's/-//g' | tr -d "\n" | awk '{print length($0)}')
			echo "No nucleotide sequences found"
			echo "Total number of amino acids: $Aminoacid_seqs"
		else
			Nucleotide_seqs=$(grep -v ">" "$file" | sed 's/-//g' | tr -d "\n" | awk '{print length($0)}')
			Aminoacid_seqs="No amino acid sequences found"
			echo "Total number of nucleotides: $Nucleotide_seqs"
		fi
	
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
	else 
		echo ###WARNING MESSAGE: The file is binary###
	fi
	
done

echo ""
Echo "Total count:"
echo "Total number of files: $files_count"
echo "Total number of IDs: $total_id_count"
