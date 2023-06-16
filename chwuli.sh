#! /bin/bash
group=$(stat -c '%G' .)
echo group: $group
chmod 2750 .
chgrp $group -R .
find . -mindepth 1 -type d -exec chmod 775 {} \;
find . -type f ! -executable -exec chmod 664 {} \;
find . -type f -executable -exec chmod 775 {} \;
