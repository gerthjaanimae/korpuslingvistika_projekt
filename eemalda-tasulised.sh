#/bin/bash
#Kõigepealt üks artikkel ühele reale.
#Seejärel võtame välja artiklid, mis sisaldavad sõnu "subscribe now to get the full story"

tr '\n' '#' |\
sed 's/<\/article>#<article>/<\/article>\n<article>/g' |\
grep -v 'subscribe now to get the full story' |\
tr '#' '\n'

