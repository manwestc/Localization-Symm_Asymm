#!/bin/bash
cat $1/output1 | grep 'HCI\|RSSI\|bdaddr' >$1/p1 
cat $1/output2 | grep 'HCI\|RSSI\|bdaddr' >$1/p2 
cat $1/output3 | grep 'HCI\|RSSI\|bdaddr' >$1/p3 
cat $1/output4 | grep 'HCI\|RSSI\|bdaddr' >$1/p4 
cat $1/output5 | grep 'HCI\|RSSI\|bdaddr' >$1/p5 
cat $1/output6 | grep 'HCI\|RSSI\|bdaddr' >$1/p6 
cat $1/output7 | grep 'HCI\|RSSI\|bdaddr' >$1/p7 
cat $1/output8 | grep 'HCI\|RSSI\|bdaddr' >$1/p8 
cat $1/output9 | grep 'HCI\|RSSI\|bdaddr' >$1/p9 
cat $1/output10 | grep 'HCI\|RSSI\|bdaddr' >$1/p10 
cat $1/output11 | grep 'HCI\|RSSI\|bdaddr' >$1/p11 
cat $1/output12 | grep 'HCI\|RSSI\|bdaddr' >$1/p12 
cat $1/output13 | grep 'HCI\|RSSI\|bdaddr' >$1/p13 
cat $1/output14 | grep 'HCI\|RSSI\|bdaddr' >$1/p14 
cat $1/output15 | grep 'HCI\|RSSI\|bdaddr' >$1/p15 
cat $1/output16 | grep 'HCI\|RSSI\|bdaddr' >$1/p16 
cat $1/output17 | grep 'HCI\|RSSI\|bdaddr' >$1/p17 



find $1 -name 'p*' -exec sed -i "s/HCI\ sniffer\ -\ Bluetooth\ packet\ analyzer\ ver\ 5.39/\ /g" {} \;
#find $1 -name 'p*' -exec sed -i "s/HCI\ sniffer\ -\ Bluetooth\ packet\ analyzer\ ver\ 5.39/\ /g" {} \;
#find $1 -name 'p*' -exec sed -i "s/>\ HCI\ Event:\ LE\ Meta\ Event\ (0x3e)\ plen\ 43/\ /g" {} \;
find $1 -name 'p*' -exec sed -i "s/\ \ \ \ bdaddr/\ /g" {} \;
find $1 -name 'p*' -exec sed -i "s/\ \ \ \ RSSI:/\ /g" {} \;
find $1 -name 'p*' -exec sed -i "s/(Random)/\ /g" {} \;
find $1 -name 'p*' -exec sed -i "s/(Public)/\ /g" {} \;
find $1 -name 'p*' -exec sed -i 's/^\(.\{26\}\).*/\1/g' {} \;

echo 'Procesa Datos usando script de c++'
 #g++ procesarDatos.cpp 
 ./a.out < $1/p1 > $1/t1
 ./a.out < $1/p2 > $1/t2
 ./a.out < $1/p3 > $1/t3
 ./a.out < $1/p4 > $1/t4
 ./a.out < $1/p5 > $1/t5
 ./a.out < $1/p6 > $1/t6
 ./a.out < $1/p7 > $1/t7
 ./a.out < $1/p8 > $1/t8
 ./a.out < $1/p9 > $1/t9
 ./a.out < $1/p10 > $1/t10
 ./a.out < $1/p11 > $1/t11
 ./a.out < $1/p12 > $1/t12
 ./a.out < $1/p13 > $1/t13
 ./a.out < $1/p14 > $1/t14
 ./a.out < $1/p15 > $1/t15
 ./a.out < $1/p16 > $1/t16
 ./a.out < $1/p17 > $1/t17

rm $1/p*

echo 'Prepara archivo usando script de Python'
python armarRuta2.py $1 > $1/final

echo 'Archivo escrito en:'$1'/final'
rm $1/output*
