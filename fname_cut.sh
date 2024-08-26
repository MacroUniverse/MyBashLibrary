#!/bin/bash

# Set the maximum length for the file name (excluding extension)
max_length=10

# Find all files in the current directory and subdirectories
find . -type f | while read -r file; do
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
            mv "$file" "$dir/$new_name"
        else
            mv "$file" "$dir/$new_name.$ext"
        fi
    fi
done
