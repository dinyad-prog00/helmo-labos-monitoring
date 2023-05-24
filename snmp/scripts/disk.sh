#!/bin/bash
set -e

# Host
HOST="192.168.128.24"
#HOST="127.0.0.1" 


# Communauty (enlevée car dépot github)
COM="<com>"

#COM="dinyad" , test en local

# Indexs disk(storage)
SI="1.3.6.1.2.1.25.2.3.1.1"

#Decription des disks
DESC="1.3.6.1.2.1.25.2.3.1.3"

#La taille de chaque unité d'allocation de stockage, en octets (Bytes)
UnitSZ="1.3.6.1.2.1.25.2.3.1.4"

#La taille totale du stockage, en unités d'allocation
TSZ="1.3.6.1.2.1.25.2.3.1.5"

#La quantité de stockage utilisée, en unités d'allocation.
USZ="1.3.6.1.2.1.25.2.3.1.6"


disk(){
    
    mkdir -p "/home/q220314/snmplabo/disk/"
    INITFILE=/home/q220314/snmplabo/disk/init.csv
    FILE=/home/q220314/snmplabo/disk/used.csv
    
    
    USED="`date +"%F %H:%M:%S"`"
    
    if [ -e "$INITFILE" ];then
        for I in `snmpwalk -v2c -c $COM -OvUq $HOST $SI`
        do
            US=`snmpwalk -v2c -c $COM -OvUq $HOST $USZ.$I`
            USED="$USED,$US"
        done;
        echo $USED  >> $FILE
    else
        H="datetime"
        UH=""
        UL=""
        TS=""
        
        for I in `snmpwalk -v2c -c $COM -OvUq $HOST $SI`
        do
            NV=`snmpwalk -v2c -c $COM -OvUq $HOST $DESC.$I`
            UV=`snmpwalk -v2c -c $COM -OvUq $HOST $UnitSZ.$I`
            T=`snmpwalk -v2c -c $COM -OvUq $HOST $TSZ.$I`
            US=`snmpwalk -v2c -c $COM -OvUq $HOST $USZ.$I`
            H="$H,$NV"
            UH="$UH,$NV"
            UL="$UL,$UV"
            TS="$TS,$T"
            USED="$USED,$US"
        done;
        
        echo ${UH:1} >> $INITFILE
        echo ${UL:1} >> $INITFILE
        echo ${TS:1} >> $INITFILE
        
        echo $H >> $FILE
        echo $USED  >> $FILE
    fi
    
}

disk


