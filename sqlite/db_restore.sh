#!/bin/bash
# restore a sqlite db file from sql file
# cmd <file_in> [<file_out>]

file_in=$1;
num_args=$#

if [ $num_args -eq 1 ]; then
	if [[ $file_in == *.db.sql ]]; then
		file_out="${file_in%.sql}"
	elif  [[ $file_in == *.sql ]]; then
		file_out="${file_in%.sql}.db"
	else
		file_out="$file_in.db"
	fi
elif [ $num_args -eq 2 ]; then
		file_out=$2
else
		echo "ERROR: usage: cmd <file_in> [<file_out>]"
		exit 1
fi

sqlite3 $file_out < $file_in
