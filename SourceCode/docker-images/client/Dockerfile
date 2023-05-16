FROM debian:stable

ENV LANG C.UTF-8


RUN apt-get -qq -y update && \
    apt-get -qq -y install \
    htop net-tools procps tcpdump wget

WORKDIR ./root/

COPY entry.sh /root/

