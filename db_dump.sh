#! /bin/bash
# stable dump of an sqlite db file
# cmd <file_in> [<file_out>]

file_in=$1;
num_args=$#

if [ $num_args -eq 1 ]; then
	file_out=$1.sql
elif [ $num_args -eq 2 ]; then
	file_out=$2
else
	echo "ERROR: usage: cmd <file_in> [<file_out>]"
	exit 1
fi

sqlite3 $file_in .dump > $file_out
sql-stab.py $file_out
mv stable-$file_out $file_out
