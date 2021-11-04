#!/bin/bash

curl -s https://fluxcd.io/install.sh | sudo bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

curl https://getmic.ro | bash
mkdir bin
mv micro bin/.

sudo az aks install-cli

rm ~/.bashrc 
ln -s ~/code/profiles/bashrc/.bashrc ~/.bashrc
source ~/.bashrc

wget https://github.com/openservicemesh/osm/releases/download/v0.11.1/osm-v0.11.1-linux-amd64.tar.gz  -O -  | tar xzvf -
sudo mv linux-amd64/osm /usr/local/bin
rm -rf linux-amd64

wget https://get.helm.sh/helm-v3.7.1-linux-amd64.tar.gz -O - | tar xzvf -
sudo mv linux-amd64/helm /usr/local/bin
rm -rf linux-amd64

sudo chown manager.manager -R ~/.azure/
az login --identity

RG=`az aks list -o json --query "[0].resourceGroup" | tr -d '\"'` 
AKS=`az aks list -o json --query "[0].name" | tr -d '\"'`

az aks get-credentials -g $RG -n $AKS 
kubelogin convert-kubeconfig -l msi 

k get pods -A