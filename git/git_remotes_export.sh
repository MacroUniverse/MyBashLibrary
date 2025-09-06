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

# Resolve absolute path for the output file
OUTPUT_FILE=$(realpath "$OUTPUT_FILE")

# Find all Git repositories and record their remotes
find "$TARGET_DIR" -type d -name ".git" -exec dirname {} \; | while read -r repo; do
    (
        cd "$repo" || exit
        git remote -v | while read -r name url type; do
            if [ -n "$name" ] && [ -n "$url" ]; then
                # Get the relative path of the repo from the target directory
                rel_path=$(realpath --relative-to="$TARGET_DIR" "$repo")
                echo "$rel_path $name $url $type"
            fi
        done
    )
done > "$OUTPUT_FILE"

echo "Remotes recorded in $OUTPUT_FILE"