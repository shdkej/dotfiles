#!/bin/bash
# minikube, kubernetes
if [ ! -e '/usr/local/bin/kubectl' ];
then
    sudo apt-get install -y apt-transport-https ca-certificates curl
    sudo curl -fsSLo /usr/share/keyrings/kubernetes-archive-keyring.gpg https://packages.cloud.google.com/apt/doc/apt-key.gpg
    echo "deb [signed-by=/usr/share/keyrings/kubernetes-archive-keyring.gpg] https://apt.kubernetes.io/ kubernetes-xenial main" | sudo tee /etc/apt/sources.list.d/kubernetes.list
    sudo apt-get update
    sudo apt-get install -y kubectl
fi
# ansible
# serverless

mkdir -p ~/.aws
cp ~/workspace/file/config ~/.aws/
cp ~/workspace/file/credentials ~/.aws/

#cp ~/workspace/file/do_backend.hcl ~/workspace/kubernetes-test/do/
#cp ~/workspace/file/do_variables.tf ~/workspace/kubernetes-test/do/
