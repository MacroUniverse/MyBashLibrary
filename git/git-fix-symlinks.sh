# must be called at the same directory of `.git` folder
# loop through all symlinks in repo

NTFSprefix=IntxLNK$'\001'

for file in \
	$(git ls-files -s | egrep '^120000' | awk '$NF != "" {print $NF}');
do
	if [[ ! -L "$file" ]]; then
		# current file is not a symlink and not empty
		# Linux might add a suffix "IntxLNK" for a symlink on NTFS
		dest=$(cat $file | tr -d '\0')
		dest="${dest#$NTFSprefix}"

		printf "[fixing] $file -> $dest\n"
		if [[ -s "$file" ]]; then
			# file is not empty
			ln -sf "$dest" "$file"
			if [[ ! -e "$file" ]]; then # dest exist
				echo "warning: destination doesn't exist."
				git checkout $file
			fi
		else
			echo "error: file is empty!"
		fi
	else
		if [[ ! -e "$file" ]]; then # dest exist
			echo "warning: destination doesn't exist."
			git checkout $file
		fi
	fi
done
