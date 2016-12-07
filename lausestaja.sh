#!/bin/bash
#Kõigepealt asendame mitte suurtähele järgneva lauselõpumärgi ja suure algustähe vahel
#oleva tühiku reavahega. See lahendab ka eesnimede lühendamise probleemi.
#Seejärel teeme sama jutumärkidega.



sed 's/\([^A-Z][.!?]\) \([A-Z0-9]\)/\1\n\2/g' |\
sed 's/\([.!?]\) \([“]\)/\1\n\2/g'

