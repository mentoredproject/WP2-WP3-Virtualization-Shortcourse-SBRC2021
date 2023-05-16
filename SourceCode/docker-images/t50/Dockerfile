FROM debian:stable

ENV LANG C.UTF-8

RUN apt-get -qq -y update && \
    apt-get -qq -y install \
    t50 htop net-tools procps tcpdump

WORKDIR ./root/

COPY entry.sh /root/
