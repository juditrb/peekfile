#!/bin/bash

file_path="$1"
num_lines="${2:-3}"  # Use 3 as the default

if [[ -f "$file_path" ]]; then
    line_count=$(wc -l < "$file_path")
    
    if [[ "$line_count" -le $((2 * num_lines)) ]]; then
        # If the file has 2X lines or less, display the full content
        echo "File content:"
        cat "$file_path"
    else
        # Display the first X lines, "..." and the last X lines
        echo "File content (partial):"
        head -n "$num_lines" "$file_path"
        echo "..."
        tail -n "$num_lines" "$file_path"
    fi
else
    echo "File not found: $file_path"
fi
