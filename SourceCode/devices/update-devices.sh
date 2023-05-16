#!/bin/bash


kubectl delete device bot -n lab1
kubectl delete device client -n lab1
kubectl delete device server -n lab1
kubectl delete device ovs -n lab1
kubectl delete device ovs-bnd -n lab1

sleep 5

kubectl apply -f devices/bot-device.yaml -n lab1

kubectl apply -f devices/server-limit-device.yaml -n lab1
  
kubectl apply -f devices/client-limit-device.yaml -n lab1

kubectl apply -f devices/ovs.yaml -n lab1

kubectl apply -f devices/ovs-bnd.yaml -n lab1
