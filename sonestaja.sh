#!/bin/bash
#Võtame välja need read, mis ei sisalda xml stiilis märgendit.
#Kasutame korpuslingvistika kodutööna valminud lausestamisskripti.
#Lööme kirjavahemärgid sõnadest lahku. Ehk siis kõik, mis ei ole suur või väiketähed, numbrid, tühikud või ülakomad.
grep -v '^<.*>$' |\
./lausestaja.sh |\
sed "s/\([^a-z^A-Z^0-9^ ^\'^-]\)/ \1/g"
