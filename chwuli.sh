#! /bin/bash
group=$(stat -c '%G' .)
echo group is $group
chmod 2750 .
chgrp $group -R .
find . -type d -exec chmod 775 {} \;
find . -type f ! -executable -exec chmod 664 {} \;
find . -type f -executable -exec chmod 775 {} \;
