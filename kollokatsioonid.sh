#!/bin/bash

# Kustutame teksti osasid tähistavad märgendid.
# Üks lause ühele reale: asendame mitte-suurtähele järgneva lauselõpumärgi ja suure algustähe vahel oleva tühiku reavahega.
# Seejärel teeme sama jutumärkidega.
# Võtame analüüsi laused, kus sisaldub sõna "apartheid".
# Asendame realõpud märgiga #, et hiljem saaks sõnapaaride analüüsis piirduda ühe lausega.
# Kustutame üleliigsed märgendid.
# Asendame tühikud reavahetustega, et igal real oleks üks sõna.
# Kustutame tühjaks jäänud read.
# Lisame iga lause lõppu neli tühikut, et oleks võimalik moodustada sõnapaare.

grep -v '<.*>' \
| sed 's/\([^A-Z][.!?]\) \([A-Z0-9]\)/\1\n\2/g' \
| sed 's/\([.!?]\) \([“]\)/\1\n\2/g' \
| grep 'apartheid' \
| tr '[A-Z]' '[a-z]' \
| sed 's/$/#/' \
| tr -d '\.\,\?\!\:\"\“\”\(\)\;' \
| tr ' ' '\n' \
| grep -v '^$' \
| sed 's/#/\n\n\n\n\n/' > read.txt

# Kustutame faili esimese sõna ja kordan seda tegevust veel viis korda, et analüüsitavate sõnapaari$

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
# Kasutame stoppsõnade nimekirja selleks, et kustutada sidesõnad jm analüüsis ebaolulised sõnad.
# Kustutame sõnad, mis tulemuses pole olulised ning mida stoppsõnade nimekiri ei eemaldanud.
# Muudame eri käänetes ja pööretes sõnad ning ainsuses ja mitmuses sõnad üheks sõnaks, et analüüs oleks täpsem ja kordusi vähem.
# Kustutame tühjaks jäänud read / jätame alles vaid read, kus on sõnad.
# Sorteerime tulemused esinemise sageduse järjekorras.'


cat paarid.txt \
| grep '[^\t]*apartheid[^\t]*' \
| sed 's/^.*apartheid.*\t$/#/' \
| sed 's/^\t.*apartheid.*$/#/' \
| grep -v '#' \
| tr '\t' '\n' \
| grep -vwf stop.txt \
| grep -v 'apartheid' \
| sed 's/african/africa/' \
| sed 's/africas/africa/' \
| sed 's/policies/policy/' \
| sed 's/boycotts/boycott/' \
| sed 's/racist/racism/' \
| sed 's/racists/racism/' \
| sed 's/boycotting/boycott/' \
| sed 's/boycotts/boycott/' \
| sed 's/israeli/israel/' \
| sed 's/israels/israel/' \
| sed 's/palestinians/palestinian/' \
| sed 's/calling/call/' \
| sed 's/calls/call/' \
| sed 's/called/call/' \
| sed 's/accusations/accuse/' \
| sed 's/comparing/compare/' \
| sed 's/compared/compare/' \
| sed 's/compares/compare/' \
| sed 's/comparison/compare/' \
| sed 's/charges/charge/' \
| sed 's/leading/lead/' \
| sed 's/campaigns/campaign/' \
| sed 's/occupied/occupation/' \
| sed 's/universities/university/' \
| sed 's/crimes/crime/' \
| sed 's/arabs/arab/' \
| sed 's/supporting/support/' \
| sed 's/supported/support/' \
| sed 's/supports/support/' \
| sed 's/reasons/reason/' \
| sed 's/zionist/zionism/' \
| sed 's/claims/claim/' \
| sed 's/accused/accuse/' \
| sed 's/accusing/accuse/' \
| sed 's/accusation/accuse/' \
| sed 's/accusations/accuse/' \
| sed 's/accuses/accuse/' \
| sed 's/occupying/occupy/' \
| sed 's/roads/road/' \
| sed 's/created/create/' \
| sed 's/creates/create/' \
| sed 's/falsely/false/' \
| sed 's/movements/movement/' \
| sed 's/practices/practice/' \
| sed 's/colonial/colonialism/' \
| sed 's/promoting/promote/' \
| sed 's/discriminatory/discriminate/' \
| grep -v '^$' \
| grep '[a-z]' \
| sort | uniq -c | sort -nr

