#!/bin/bash
set -e
# Host
HOST="192.168.128.24"


# Communauty (enlevée car dépot github)
COM="<com>"

# List NIC names
NIC=".1.3.6.1.2.1.2.2.1.2"

# Get Bytes IN
IN=".1.3.6.1.2.1.2.2.1.10"

# Get Bytes OUT
OUT=".1.3.6.1.2.1.2.2.1.16"




# arg : nic id
interface(){

    NAME=`snmpwalk -v2c -c $COM -OvqU $HOST $NIC.$1`
    bIN=`snmpwalk -v2c -c $COM -OvUq $HOST $IN.$1`
    bOUT=`snmpwalk -v2c -c $COM -OvUq $HOST $OUT.$1`

    # Create log
    mkdir -p "/home/q220314/snmplabo/if-in-out/$NAME"
    FILE=/home/q220314/snmplabo/if-in-out/$NAME/trafic-`date +%h%d%y`.csv

    

    if [ -e "$FILE" ];then
        echo "`date +"%F %H:%M:%S"`,$bIN,$bOUT" >> $FILE
    else
        echo "datetime,in,out" >> $FILE
        echo "`date +"%F %H:%M:%S"`,$bIN,$bOUT" >> $FILE
    fi

}

interfaces(){

    for ID in `snmpwalk -v2c -c $COM -Oa $HOST $NIC | awk '{ print $1 }' | awk -F "." '{print $NF}'`
    do
        interface $ID
    done;

   
    # Create log for all if (sum)
    mkdir -p "/home/q220314/snmplabo/if-in-out/all-ifs"
    FILE=/home/q220314/snmplabo/if-in-out/all-ifs/trafic-`date +%h%d%y`.csv

    bIN=`snmpwalk -v2c -c $COM -OvUq $HOST $IN | awk 'BEGIN{S=0} {S+=$1} END{print S}'`
    bOUT=`snmpwalk -v2c -c $COM -OvUq $HOST $OUT | awk 'BEGIN{S=0} {S+=$1} END{print S}'`

    if [ -e "$FILE" ];then
        echo "`date +"%F %H:%M:%S"`,$bIN,$bOUT" >> $FILE
    else
        echo "datetime,in,out" >> $FILE
        echo "`date +"%F %H:%M:%S"`,$bIN,$bOUT" >> $FILE
    fi

}

interfaces

