#!/bin/bash

# Default input file
INPUT_FILE="git_remotes.txt"

# Usage message
usage() {
    echo "Usage: $0 [target_directory] [input_file]"
    echo "  target_directory: Directory where repositories are located (default: current directory)"
    echo "  input_file: File containing recorded remotes (default: git_remotes.txt)"
}

# Parse arguments
TARGET_DIR="${1:-.}"
INPUT_FILE="${2:-git_remotes.txt}"

# Check if target directory exists
if [ ! -d "$TARGET_DIR" ]; then
    echo "Error: Directory $TARGET_DIR does not exist."
    usage
    exit 1
fi

# Check if input file exists
if [ ! -f "$INPUT_FILE" ]; then
    echo "Error: Input file $INPUT_FILE does not exist."
    usage
    exit 1
fi

# Process each line in the input file
while read -r rel_path name url type; do
    repo_path="$TARGET_DIR/$rel_path"
    if [ -d "$repo_path" ]; then
        (
            cd "$repo_path" || exit
            # Remove remote if it already exists
            if git remote get-url "$name" &>/dev/null; then
                git remote remove "$name"
            fi
            # Add the remote
            git remote add "$name" "$url"
            # Set push URL if it's a push remote
            if [ "$type" = "(push)" ]; then
                git remote set-url --push "$name" "$url"
            fi
            echo "Configured remote '$name' in $rel_path"
        )
    else
        echo "Warning: Repository $rel_path not found in $TARGET_DIR"
    fi
done < "$INPUT_FILE"

echo "Remotes import completed."