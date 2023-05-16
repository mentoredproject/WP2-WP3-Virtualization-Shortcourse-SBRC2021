WAIT_TOPO_END (){
    NODES=($(kubectl get nodes -o name | cut -d'/' -f2))

    i=0
    while [[ ${#NODES[@]} > 1 ]]; do
        i=$((i+1))
        #echo ${#CLIENTS[@]}

        NODES=()
        NODES=($(kubectl get pods -n lab1  -o name | cut -d'/' -f2))
        
        printf "\rWaiting older topology end... %02d s" $i 
        sleep 1
    done

    printf "\nContinue... \n"
}

WAIT_CLUSTER_START (){
    PODS=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running | wc -l)
    i=0
    echo "WAIT CLUSTER START"
    while [[ $PODS < $1 ]]; do
        i=$((i+1))
    
        printf "\rWaiting cluster start... %02d s  %d/%d" $i $PODS $1
    
        sleep 1
    
        PODS=$(kubectl get pods --all-namespaces --field-selector=status.phase=Running | wc -l)
        if [[ $(($i % 800)) == 0 ]];
        then
            kubectl rollout restart deployment nmstate-webhook -n cluster-network-addons
            kubectl rollout restart deployment kubemacpool-mac-controller-manager -n cluster-network-addons
            kubectl rollout restart deployment cluster-network-addons-operator -n cluster-network-addons
        fi
    done

    printf "\nContinue... \n"
}




WAIT_TOPO_START (){
    NODES=($(kubectl get nodes -o name | cut -d'/' -f2))
    i=0
    while [[ ${#NODES[@]} > 1 ]]; do
        i=$((i+1))
        #echo ${#CLIENTS[@]}

        NODES=()
        NODES=($(kubectl get pods -n lab1  -o name | cut -d'/' -f2))
        
        printf "\rWaiting older topology end... %02d s" $i 
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


CLUSTER_NAME=demo
kind delete cluster --name knetlab



WAIT_TOPO_END

echo "Creating kind clusters ..."

kind create cluster --name knetlab --config kind-cluster/config_file


echo "Installing multus and ovs-cli..."

kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.50.0/namespace.yaml
kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.50.0/network-addons-config.crd.yaml
kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.50.0/operator.yaml
kubectl apply -f https://github.com/kubevirt/cluster-network-addons-operator/releases/download/v0.50.0/network-addons-config-example.cr.yaml



WAIT_CLUSTER_START 16

docker network connect "kind" "kind-registry"

for node in $(kubectl get nodes -o name | grep worker | cut -d'/' -f2 )
do
    #echo "Installing ovs in $node ..."
    docker exec -it $node apt update
    docker exec -it $node apt -y upgrade
    docker exec -it $node sh -c "DEBIAN_FRONTEND=noninteractive apt install -y openvswitch-switch"
    docker exec -it $node systemctl enable --now openvswitch-switch
    docker exec -it $node ovs-vsctl set-manager ptcp:6640
    kubectl annotate node "${node}" "kind.x-k8s.io/registry=172.18.0.2:5000";

done

kubectl label --overwrite nodes knetlab-worker region.id=rn
kubectl label --overwrite nodes knetlab-worker2 region.id=sc
kubectl label --overwrite nodes knetlab-worker3 region.id=pb


echo "Installing control plane knetlab-control-plane ..."

kubectl apply -f knetlab/knetlab-control-plane/src/main/resources/deployment/knetlab.yaml

WAIT_CLUSTER_START 41

echo "Creating Lab1"
kubectl apply -f labs/lab-cr.yaml

WAIT_CLUSTER_START 42

./restart.sh $topo

