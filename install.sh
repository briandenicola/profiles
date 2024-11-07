#!/bin/bash

sudo apt upgrade
sudo apt upgrade jq zsh kubecolor -y

cp .banner.rc ~/.
cp .aliases.rc-simple ~/.aliases.rc
cp bashrc/.bashrc ~/.

cp vim/_vimrc-codespaces ~/.vimrc
cp zsh/.zshrc-codespaces ~/.zshrc