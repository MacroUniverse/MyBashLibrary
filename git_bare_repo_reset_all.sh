#! /usr/bin/bash

# checkout directly from bare repos in another folder
# to all subfolders in current directory

for repo in */ ; do
  repo=${repo%/}
  gitdir="/mnt/data/MacroUniverse/$repo/.git"
  if ! [ -d $gitdir ]; then
    continue;
  fi

  printf "\n\n===============================\n"
  echo "$repo"
  printf "===============================\n\n"
  cd $repo
  ####
  dirflag="--work-tree=. --git-dir=$gitdir"
  echo git $dirflag reset --hard
  git $dirflag reset --hard

  echo git ... clean -fd
  git $dirflag clean -fd
  ####
  cd - > /dev/null
done
