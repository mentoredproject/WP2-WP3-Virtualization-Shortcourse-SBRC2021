#!/bin/bash


docker rmi 172.18.0.2:5000/nelson/$1
#docker rmi ghcr.io/ngpjunior/$1:latest

docker build -t nelson/$1 .

docker tag nelson/$1:latest 172.18.0.2:5000/nelson/$1:latest
docker push 172.18.0.2:5000/nelson/$1:latest
docker pull 172.18.0.2:5000/nelson/$1:latest

#docker tag nelson/$1:latest ghcr.io/ngpjunior/$1:latest
#docker push ghcr.io/ngpjunior/$1:latest
#docker pull ghcr.io/ngpjunior/$1:latest
