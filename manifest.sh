#!/bin/bash

# check if the list of folders in current directory is the same as listed in `manifest.txt`
# print any difference

# create an associative array
declare -A manifest_folders

# Read the folders from the manifest.txt file
while IFS= read -r folder
do
    # Add to the associative array
    manifest_folders["$folder"]=1
done < ~/github/Notes/Files/MacroUniverse.txt

# Print folders that do not exist
for folder in "${!manifest_folders[@]}"; do
    if [ ! -d "$folder" ]; then
        echo "Folder in manifest but does not exist: $folder"
    fi
done

# Check every directory in the current location against the manifest
for dir in */ ; do
    dir=${dir%*/} # remove the trailing "/"
    if [[ -z "${manifest_folders[$dir]}" ]]; then
        echo "Folder exists but not in manifest: $dir"
    fi
done

echo "done!"

