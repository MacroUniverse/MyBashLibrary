# must be called at the same directory of `.git` folder
# loop through all symlinks in repo
for file in \
	$(git ls-files -s | egrep '^120000' | awk '$NF != "" {print $NF}');
do
	if [[ ! -L "$file" ]]; then
		# current file is not a symlink and not empty
		printf "[fixing] $file -> $(cat $file)\n"
		if [[ -s "$file" ]]; then
			# file is not empty
			ln -sf "$(cat $file)" "$file"
			if [[ ! -e "$file" ]]; then # dest exist
				echo "warning: destination doesn't exist."
			fi
		else
			echo "file is empty!"
		fi
	fi
done
