FROM debian:stable

ENV LANG C.UTF-8

RUN apt-get -qq -y update && \
    apt-get -qq -y install \
    tcpdump htop net-tools procps python3 python3-matplotlib python3-pandas 
RUN DEBIAN_FRONTEND=noninteractive apt-get install -y tshark


WORKDIR ./root/

COPY entry.sh /root

COPY plot-bandwidth.py /root

