#!/bin/bash

for i  in  $(ls ./); do
    
    if cd "$i" ; then
    	echo $i
    	../docker-push.sh "$i" #>> /dev/null
    	cd ..
	fi

done
