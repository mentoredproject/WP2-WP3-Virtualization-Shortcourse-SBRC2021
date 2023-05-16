FROM debian:stable


RUN apt update; apt upgrade -y; apt install -y sudo nload iputils-ping iptables t50 apt-utils tcpreplay wget net-tools iproute2 build-essential python3-pip git vim tcpdump traceroute; python3 -m pip install --upgrade pip; pip3 install cython numpy scikit-learn scapy pandas matplotlib netifaces 


RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tshark


WORKDIR ./root/

COPY entry.sh /root/
COPY bandwidth.py /root/
