#!/bin/bash
#Skript, mis kontrollib, kui kaugele Jerusalem  Postist andmete kogumine jõudnud on.
# 7-8 Kõigepealt vaatame logifailist, milline on viimane link, mida vaadati.
#9-11 Siis mis kuupäevani skript jõudnud on.
# 12-13Lõpuks vaatame, kui kaua skript jooksnud on.

echo Viimane link:
tail -1 jpost.log
echo Viimane kuupäev:
grep 'Archive.aspx' jpost.log | tail -1 |\
sed 's/.*date=//g'
p=$(pgrep python)
ps -p $p -o etime
