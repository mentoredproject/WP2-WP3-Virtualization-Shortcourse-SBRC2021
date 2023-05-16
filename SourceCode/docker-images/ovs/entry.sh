#!/bin/sh

/usr/share/openvswitch/scripts/ovs-ctl start 
ovs-vsctl add-br br0

for i  in  $(ifconfig -a | sed 's/[: \t].*//;/^$/d'); do
    if [ "$i" != "eth0" ] && [  "$i" != "lo" ]
    then
        ovs-vsctl add-port br0 "$i"
    fi
done

tail -f /dev/null