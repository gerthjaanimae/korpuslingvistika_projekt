#!/bin/bash
#Teeme kõigepealt sisendfaili tühjaks.
#Vaatame tsükliliselt määratud kaustas olevad failid läbi.
#Kirjutame vajalikud märgendid faili.
#Muudame pealkirja ja kuupäeva rida nii, et see sobiks märgendite vahele.
#Seejärel paneme sinna ka sisu.
#Kuna selgus, et printf funktsioon saab reavahedega paremini hakkama kui echo, siis kasutame aeg-ajalt seda.


> $1.txt
for filename in $1/*.txt; do
echo '<article>' >> $1.txt

grep 'Title: ' $filename |\
sed 's/Title: \(.*\)$/<title>\1<\/title>/' >> $1.txt
grep 'Date: ' $filename |\
sed 's/Date: \(.*\)$/<date>\1<\/date>/' >> $1.txt
echo '<content>' >> $1.txt
tail -n +3 $filename >> $1.txt
printf '\n</content>\n' >> $1.txt
echo '</article>' >> $1.txt
done
