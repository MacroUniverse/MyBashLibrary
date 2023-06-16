#! /bin/bash
group=$(stat -c '%G' .)
echo group: $group
chgrp $group -R .
chmod 2770 .
find . -mindepth 1 -type d -exec chmod 2775 {} \;
find . -type f -executable -exec chmod 775 {} \;
find . -type f ! -executable -exec chmod 664 {} \;
