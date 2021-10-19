#!/bin/bash

Targets='192.168.0.1 heise.de google.com 1.1.1.1'
Interfaces='eth0 wlan0'
SaveFile="${HOME}/Pinglogger/ping.log"

FormatPing ()
{
    # $1 should be interface
    # $2 should be target
    PingResult=$(ping -c 1 -w 1 -I ${1} ${2})
    PingReturn=${?}
    PingResult1=$(echo ${PingResult} | cut -d',' -f3-)
    echo -n `date +%FT%H:%M:%S`
    echo -n ",${1}"
    echo -n ",${2}"
    echo -n ",${PingReturn}"
    # Package loss, not needed
    #echo  ${PingResult1} | awk 'BEGIN {ORS=""}{print $1}'
    if [ ${PingReturn} -eq 0 ]
    then
        echo -n ","
        echo -n ${PingResult1} | awk -F/ '{print $5}'
    else
        echo
    fi
}

if [ -z $1 ]
then
for i in ${Targets}
do
    for j in ${Interfaces}
    do
        FormattedPing ${j} ${i}
    done
done
else ### Save file
if test ! -f ${SaveFile}
then
    mkdir -p $(dirname ${SaveFile})
    touch ${SaveFile}
    echo "Time,Interface,Target,RC,RTT" >> ${SaveFile}
fi
echo "Log is saved in ${SaveFile}"

for i in ${Targets}
do
    for j in ${Interfaces}
    do
        FormatPing ${j} ${i} >> ${SaveFile}
    done
done
fi
