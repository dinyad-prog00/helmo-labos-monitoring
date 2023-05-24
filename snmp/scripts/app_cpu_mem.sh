#!/bin/bash
set -e

# Host
HOST="192.168.128.24"
#HOST="127.0.0.1"


# Communauty (enlevée car dépot github)
COM="<com>"

#COM="dinyad"


# Run indexes
RI="1.3.6.1.2.1.25.4.2.1.1"

#Run name
RN="1.3.6.1.2.1.25.4.2.1.2"

#Run type
RT="1.3.6.1.2.1.25.4.2.1.6"

#Run status
RS="1.3.6.1.2.1.25.4.2.1.7"

#Run CPU
RCPU="1.3.6.1.2.1.25.5.1.1.1"

#Run memory
RMem="1.3.6.1.2.1.25.5.1.1.2"

app_cpu_mem_use(){

    
    H="datetime"
    MEMS=`date +"%F %H:%M:%S"`
    CPUS=`date +"%F %H:%M:%S"`
    for I in `snmpwalk -v2c -c $COM -Ovq $HOST $RI`
    do 
        type=`snmpwalk -v2c -c $COM -Ovq $HOST $RT.$I`
        if [ "$type" == "application" ];then
            name=`snmpwalk -v2c -c $COM -Ovq $HOST $RN.$I`
            cpu=`snmpwalk -v2c -c $COM -Ovq $HOST $RCPU.$I`
            mem=`snmpwalk -v2c -c $COM -OvUq $HOST $RMem.$I`
            H="$H,${name:1:-1}"
            CPUS="$CPUS,$cpu"
            MEMS="$MEMS,$mem"
        fi
    done;

    echo $H > ttt
    echo $CPUS >> ttt
    echo $MEMS >> ttt

    
    # # Create log
    
    mkdir -p "/home/q220314/snmplabo/app/"
    FILECPU=/home/q220314/snmplabo/app/app-cpu-use.csv
    FILEMEM=/home/q220314/snmplabo/app/app-mem-use.csv
    

    if [ -e "$FILECPU" ];then
        echo $CPUS >> $FILECPU
        echo $MEMS >> $FILEMEM
    else
        echo $H >> $FILECPU
        echo $CPUS >> $FILECPU

        echo $H >> $FILEMEM
        echo $MEMS >> $FILEMEM
    fi
    
}

app_cpu_mem_use