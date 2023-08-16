#! /usr/bin/bash
# pull all subdirectories from default remote

for repo in */ ; do
  repo=${repo%/}
  if ! [ -d "$repo/.git" ]; then
    continue;
  fi

  cd $repo
  if [ -n "$(git remote | grep github)" ]; then
    printf "\n\n===============================\n"
    echo "$repo"
    printf "===============================\n\n"
  	git push github
  fi
  cd - > /dev/null
done
