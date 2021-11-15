#!/bin/bash

sudo apt install jq -y

curl -s https://fluxcd.io/install.sh | sudo bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

curl https://getmic.ro | bash
mkdir bin
mv micro bin/.

sudo az aks install-cli

wget https://github.com/openservicemesh/osm/releases/download/v0.11.1/osm-v0.11.1-linux-amd64.tar.gz  -O -  | tar xzvf -
sudo mv linux-amd64/osm /usr/local/bin
rm -rf linux-amd64

curl -L https://istio.io/downloadIstio | sh -
sudo mv istio-1*/bin/istioctl /usr/local/bin/
rm -rf istio-*

wget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz -O - | tar xzvf -
sudo mv linux-amd64/helm /usr/local/bin
rm -rf linux-amd64

wget https://github.com/derailed/k9s/releases/download/v0.24.15/k9s_Linux_x86_64.tar.gz -O - | tar xzvf -
sudo mv k9s /usr/local/bin/
rm LICENSE
rm README.md

sudo chown manager.manager -R ~/.azure/
az login --identity

RG=`az aks list -o json --query "[0].resourceGroup" | tr -d '\"'` 
AKS=`az aks list -o json --query "[0].name" | tr -d '\"'`

az aks get-credentials -g $RG -n $AKS 
kubelogin convert-kubeconfig -l msi 

rm ~/.bashrc 
ln -s ~/code/profiles/bashrc/.bashrc ~/.bashrc
source ~/.bashrc

kubectl get pods -A