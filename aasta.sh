#/bin/bash
#Kõigepealt üks artikkel ühele reale.

tr '\n' '#' |\
sed 's/<\/article>#<article>/<\/article>\n<article>/g' |\
grep  $1'</date>' |\
tr '#' '\n'

