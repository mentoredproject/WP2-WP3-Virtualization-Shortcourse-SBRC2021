sudo apt install docker.io net-tools docker curl apt-transport-https

curl -LO https://storage.googleapis.com/kubernetes-release/release/`curl -s https://storage.googleapis.com/kubernetes-release/release/stable.txt`/bin/linux/amd64/kubectl -o /usr/local/bin/kubectl                 
chmod +x ./kubectl                                                                      
chmod a+x ./kubectl                                                                     
sudo mv ./kubectl /usr/local/bin/kubectl                                                

curl -Lo /usr/local/bin/ https://kind.sigs.k8s.io/dl/v0.11.1/kind-linux-amd64                    
chmod +x ./kind                         
