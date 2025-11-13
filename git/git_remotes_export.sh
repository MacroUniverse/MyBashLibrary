#!/bin/bash

# Default output file
OUTPUT_FILE="git_remotes.txt"

# Usage message
usage() {
    echo "Usage: $0 [directory] [output_file]"
    echo "  directory: Directory to scan for Git repositories (default: current directory)"
    echo "  output_file: File to save the remotes (default: git_remotes.txt)"
}

# Parse arguments
TARGET_DIR="${1:-.}"
OUTPUT_FILE="${2:-git_remotes.txt}"

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR does not exist."
    usage
    exit 1
fi

# Resolve absolute paths
TARGET_DIR=$(realpath "$TARGET_DIR")
OUTPUT_FILE=$(realpath "$OUTPUT_FILE")

# Process each direct subdirectory
for subdir in "$TARGET_DIR"/*/; do
    # Remove trailing slash
    subdir=${subdir%*/}
    git_dir="$subdir/.git"
    
    # Check if it's a Git repository
    if [ -d "$git_dir" ]; then
        (
            cd "$subdir" || exit
            git remote -v | while read -r name url type; do
                if [ -n "$name" ] && [ -n "$url" ]; then
                    # Get just the directory name (not full path)
                    dir_name=$(basename "$subdir")
                    echo "$dir_name $name $url $type"
                fi
            done
        )
    fi
done > "$OUTPUT_FILE"

echo "Remotes recorded in $OUTPUT_FILE"
