FROM globocom/openvswitch:2.8.1

ENV LANG C.UTF-8

RUN apk update && \
    apk add \
    tcpdump htop net-tools procps


WORKDIR ./root/

COPY ./entry.sh /root
