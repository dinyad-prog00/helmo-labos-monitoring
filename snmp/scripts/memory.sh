#!/bin/bash
set -e

# Host
HOST="192.168.128.24"


# Communauty (enlevée car dépot github)
COM="<com>"

#Total RAM in machine:
RM=".1.3.6.1.4.1.2021.4.5.0"

#Total RAM used:
RU=".1.3.6.1.4.1.2021.4.6.0"

#Total RAM Free:
RF=".1.3.6.1.4.1.2021.4.11.0"

#Total RAM Shared:
RS=".1.3.6.1.4.1.2021.4.13.0"

#Total RAM Buffered:
RB=".1.3.6.1.4.1.2021.4.14.0"

#Total Swap Size:
SZ=".1.3.6.1.4.1.2021.4.3.0"

#Available Swap Space:
SS=".1.3.6.1.4.1.2021.4.4.0"

#Total Cached Memory:
CM=".1.3.6.1.4.1.2021.4.15.0"

memory(){

    S=`date +"%F %H:%M:%S"`
    for I in $RM $RU $RF $RS $RB $SZ $SS $CM 
    do 
        V=`snmpwalk -v2c -c $COM -OvUq $HOST $I`
        S="$S,$V"
    done;

    # Create file
    mkdir -p "/home/q220314/snmplabo/memory/"
    FILE=/home/q220314/snmplabo/memory/hist-`date +%h%d%y`.csv
    
    if [ -e "$FILE" ];then
        echo $S  >> $FILE
    else
        echo "datetime,rm,ru,rf,rs,rb,sz,ss,cm" >> $FILE
        echo $S  >> $FILE
    fi
    
}

memory