#!/bin/bash

find . -name "*.ts" -type f | while IFS= read -r file
do
    mp4_file="${file%.ts}.mp4"
    if [[ -e "$mp4_file" ]]
    then
		echo "\"$mp4_file\""
        mv "$mp4_file" "/mnt/z/电影.pbu/电影.ffmpeg-out"
    fi
done
