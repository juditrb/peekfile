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
	if grep -q ">" "$file" ; then

		#Printing the name of each file
	
		echo "<<<< $file >>>>"

		#An "if" is used to know if the file is a symlink or not, printing this information in the output
		if [[ -h "$file" ]]; then
			echo "SYMLINK"
		else
			echo "NO SYMLINK"
		fi

		#As each sequence is preceded by its ">ID", grep is used to search for the ">" symbol into the file, counting the total sequences that are there. 
		num_sequences=$(grep -c ">" "$file")
		echo There are "$num_sequences" sequences in the file

		#Counting nucleotides and amino acids depending on whether the sequence contains or does not contain the letters of the amino acids, which are RDQEHILKMFSWYVrdqehilkmfswyv. 
			#Amino acid letters matching the nucleotides letters (AGCTUNagctun) are extracted from the pattern.  

		if grep -v ">" "$file" | grep -q '[RDQEHILKMFSWYVrdqehilkmfswyv]'; then
			Aminoacid_seqs=$(grep -v ">" "$file" | sed 's/-//g' | tr -d "\n" | awk '{print length($0)}')
			echo "The file contains amino acid sequences"
			echo "Total number of amino acids: $Aminoacid_seqs"
		else
			Nucleotide_seqs=$(grep -v ">" "$file" | sed 's/-//g' | tr -d "\n" | awk '{print length($0)}')
			echo "The file contains nucleotide sequences"
			echo "Total number of nucleotides: $Nucleotide_seqs"
		fi
	
		echo ""

		#Printing full content of file or some lines depending on the number of lines. 
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
	
	#If the file is empty to print that it has no content.
	#If the file doesn't contain ">" symbol and it is not empty, to print a warning message saying that is a binary file.

	elif ! [[ -s "$file" ]]; then
		echo "<<<< $file >>>>"
		echo "The file is empty"
		echo ""
	else 
		echo "<<<< $file >>>>"
		echo ###WARNING MESSAGE: It is a binary file###
		echo ""
	fi
	
done

echo ""

#Printing the total number of files and IDs using the counter variables files_count and total_id_count. 
echo "Total number of files: $files_count"
echo "Total number of IDs: $total_id_count"

echo ""