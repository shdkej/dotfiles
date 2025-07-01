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
# helm
if [ ! -e '/usr/local/bin/helm' ];
then
    curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
    chmod 700 get_helm.sh
    ./get_helm.sh
    rm ./get_helm.sh
fi
# vagrant
# terraform
if [ ! -e '/usr/local/bin/terraform' ];
then
    wget https://releases.hashicorp.com/terraform/0.15.1/terraform_0.15.1_linux_amd64.zip
    unzip terraform_0.15.1_linux_amd64.zip
    sudo mv terraform /usr/local/bin
    rm terraform_0.15.1_linux_amd64.zip
fi
# ansible
# serverless

mkdir -p ~/.aws
cp ~/workspace/file/config ~/.aws/
cp ~/workspace/file/credentials ~/.aws/

#cp ~/workspace/file/do_backend.hcl ~/workspace/kubernetes-test/do/
#cp ~/workspace/file/do_variables.tf ~/workspace/kubernetes-test/do/
