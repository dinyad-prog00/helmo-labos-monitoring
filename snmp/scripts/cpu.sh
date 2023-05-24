#!/bin/bash
set -e

# Host
HOST="192.168.128.24"



# Communauty (enlevée car dépot github)
COM="<com>"


#1 minute Load: 
M1=".1.3.6.1.4.1.2021.10.1.3.1"

#5 minute Load: 
M5=".1.3.6.1.4.1.2021.10.1.3.2"

#15 minute Load: 
M15=".1.3.6.1.4.1.2021.10.1.3.3"

#percentage of user CPU time:
PUT=".1.3.6.1.4.1.2021.11.9.0"

#raw user cpu time:
RUT=".1.3.6.1.4.1.2021.11.50.0"

#percentages of system CPU time:
PST=".1.3.6.1.4.1.2021.11.10.0"

#raw system cpu time:
RST=".1.3.6.1.4.1.2021.11.52.0"

#percentages of idle CPU time:
PIT=".1.3.6.1.4.1.2021.11.11.0"

#raw idle cpu time:
RIT=".1.3.6.1.4.1.2021.11.53.0"

#raw nice cpu time:
RNT=".1.3.6.1.4.1.2021.11.51.0"

cpu_load(){

    S=`date +"%F %H:%M:%S"`
    for I in $M1 $M5 $M15 $PUT $RUT $PST $RST $PIT $RIT $RNT
    do 
        V=`snmpwalk -v2c -c $COM -OvUq $HOST $I`
        S="$S,$V"
    done;
    # Create log
    
    mkdir -p "/home/q220314/snmplabo/cpu/"
    FILE=/home/q220314/snmplabo/cpu/load-`date +%h%d%y`.csv
    

    if [ -e "$FILE" ];then
        echo $S  >> $FILE
    else
        echo "datetime,1m,5m,15m,put,rut,pst,rst,pit,rit,rnt" >> $FILE
        echo $S  >> $FILE
    fi
    
}

cpu_load