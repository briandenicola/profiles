#!/bin/bash

curl -s https://fluxcd.io/install.sh | sudo bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash

sudo az aks install-cli

rm ~/.bashrc 
ln -s ~/code/profiles/bashrc/.bashrc ~/.bashrc
source ~/.bashrc

sudo chown manager.manager -R ~/.azure/
az login --identity

RG=`az aks list -o json --query "[0].resourceGroup" | tr -d '\"'` 
AKS=`az aks list -o json --query "[0].name" | tr -d '\"'`

az aks get-credentials -g $RG -n $AKS 
kubelogin convert-kubeconfig -l msi 

k get pods -A