    
WAIT_TOPO_END (){
    CLIENTS=($(kubectl get pods -n lab1  -o name | cut -d'/' -f2))

    i=0
    while [[ ${#CLIENTS[@]} > 1 ]]; do
        i=$((i+1))
        #echo ${#CLIENTS[@]}

        
        CLIENTS=(z$(kubectl get pods -n lab1  -o name | cut -d'/' -f2))

        printf "\rTerminating older topology... %02d s" $i 
        sleep 1
    done

    printf "\nContinue... \n"
}

WAIT_TOPO_START (){

    CLIENTS=($(kubectl get pods -n lab1  | grep "Running" | cut -d'/' -f2))

    i=0
    while [[ ${#CLIENTS[@]} < 2  ]]; do
        i=$((i+1))
        echo ${#CLIENTS[@]}

        CLIENTS=($(kubectl get pods -n lab1  | grep "Running" | cut -d'/' -f2))

        printf "\rWAITING TOPOLOGY START... %02d s" $i 
        sleep 1
    done

    printf "\nContinue... \n"
}


if [[ $1 != "" ]];
then
    topo=$1    
    echo $1
else
    
    topo="./topos/client-server-bot.yaml"
    echo "default client-server-bot.yaml topology in use"
fi
cd docker-images
./push-all.sh > /dev/null &
cd ..

kubectl delete topology -n lab1 topo-host

sleep 5

kubectl get pods -n lab1


WAIT_TOPO_END;


./devices/update-devices.sh

sleep 6

kubectl apply -f $topo -n lab1


WAIT_TOPO_START;

sleep 5
watch kubectl get pods -n lab1

