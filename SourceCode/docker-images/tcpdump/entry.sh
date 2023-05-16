#!/bin/bash

mkdir /root/resultados/

ifconfig $NETINTERFACE 192.168.1.$SERVER

touch /root/resultados/$NETINTERFACE.pcap


tcpdump -i $NETINTERFACE -w /root/resultados/$NETINTERFACE.pcap &
CAP_PID=$!
sleep 120


pkill tcpdump
sleep 30
python3 plot-bandwidth.py

tail -f /dev/null