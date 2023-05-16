#!/bin/bash


ifconfig $NETINTERFACE 192.168.1.$CLIENT

while :; do
	time1=$(($(shuf -i 0-3 -n 1)/2))
	time2=$(($(shuf -i 0-100 -n 1)/2))
    sleep $time1.$time2
    echo $time1.$time2
    wget  192.168.1.$SERVER -O /dev/null  2>&1 | grep -oP '(?<= \()\d+\.?\d+ \SB/s(?=\) )' >> log.txt
done
