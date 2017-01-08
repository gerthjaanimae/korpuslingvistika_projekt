#!/bin/bash

# Asendame mitte-suurtähele järgneva lauselõpumärgi ja suure algustähe vahel oleva tühiku reavahega. See lahendab ka eesnimede lühendamise probleemi.
# Seejärel teeme sama jutumärkidega.
# Võtame analüüsi laused, kus sisaldub sõna "apartheid"
# Asendame realõpud märgiga #, et hiljem saaks sõnapaaride analüüsis piirduda ühe lausega.
# Kustutame üleliigsed märgendid.
# Asendame tühikud reavahetustega, et igal real oleks üks sõna.
# Kustutame tühjaks jäänud read.
# Lisame iga lause lõppu neli tühikut, et oleks võimalik moodustada sõnapaare.

sed 's/\([^A-Z][.!?]\) \([A-Z0-9]\)/\1\n\2/g' \
| sed 's/\([.!?]\) \([“]\)/\1\n\2/g' \
| grep 'apartheid' \
| tr '[A-Z]' '[a-z]' \
| sed 's/$/#/' \
| tr -d '\.\,\?\!\:\"\“\”\-\(\)\;' \
| tr ' ' '\n' \
| grep -v '^$' \
| sed 's/#/\n\n\n\n\n/' > read.txt

# Kustutame faili esimese sõna ja kordan seda tegevust veel viis korda, et analüüsitavate sõnapaaride vahel oleks 0-5 sõna.

cat read.txt | tail -n +2 > read-1.txt
cat read.txt | tail -n +3 > read-2.txt
cat read.txt | tail -n +4 > read-3.txt
cat read.txt | tail -n +5 > read-4.txt
cat read.txt | tail -n +6 > read-5.txt
cat read.txt | tail -n +7 > read-6.txt

# Lisame kõik tekkinud sõnapaarid ühte sõnapaaride faili.

paste read.txt read-1.txt > paarid.txt
paste read.txt read-2.txt >> paarid.txt
paste read.txt read-3.txt >> paarid.txt
paste read.txt read-4.txt >> paarid.txt
paste read.txt read-5.txt >> paarid.txt
paste read.txt read-6.txt >> paarid.txt

# Analüüsime ainult neid sõnapaare, milles sisaldub sõna "apartheid".
# Asendame need tulemused, kus paare ei moodustunud, märgiga # ja siis kustutame need read.
# Asendame paaride vahed reavahega, et jätta analüüsiks alles vaid sõnaga "apartheid" koos esinevad sõnad.
# Sorteerime tulemused esinemise sageduse järjekorras.

cat paarid.txt \
| grep '[^\t]*apartheid[^\t]*' \
| sed 's/^.*apartheid.*\t$/#/' \
| sed 's/^\t.*apartheid.*$/#/' \
| grep -v '#' \
| tr '\t' '\n' \
| grep -v 'apartheid' \
| sort | uniq -c | sort -nr