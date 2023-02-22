#! /usr/bin/bash
# pull all subdirectories from default remote

for repo in */ ; do
  repo=${repo%/}
  if ! [ -d "$repo/.git" ]; then
    continue;
  fi

  printf "\n\n\n===============================\n"
  echo "$repo"
  printf "===============================\n\n\n"
  cd $repo &&
  git pull &&
  cd - > /dev/null
done
