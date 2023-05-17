#! /bin/bash
# pull all subdirectories from default remote

repos=littleshi.cn PhysWiki PhysWikiScan PhysWiki-backup user-notes

for repo in ${repos} ; do
  repo=${repo%/}
  if ! [ -d "$repo/.git" ]; then
    continue;
  fi

  printf "\n\n===============================\n"
  echo "$repo"
  printf "===============================\n\n"
  cd $repo &&
  git pull &&
  cd - > /dev/null
done
