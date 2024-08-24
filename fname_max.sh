#!/bin/bash

# Set the maximum length for the file name (excluding extension)
max_length=130

# Find all files in the current directory and subdirectories
find . | while read -r file; do
    # Extract the directory, filename, and extension
    dir=$(dirname "$file")
    base=$(basename "$file")
    
    if [[ "$base" == *.* ]]; then
        name="${base%.*}"
        ext="${base##*.}"
    else
        name="$base"
        ext=""
    fi

    # Check if the file name exceeds the maximum length
    if [ ${#name} -gt $max_length ]; then
        # Truncate the file name
        new_name=$(echo "$name" | cut -c1-$max_length)
        # Rename the file
        if [ -z "$ext" ]; then
			echo "$file -> $dir/$new_name"
            mv "$file" "$dir/$new_name"
        else
			echo "$file -> $dir/$new_name.$ext"
            mv "$file" "$dir/$new_name.$ext"
        fi
    fi
done

