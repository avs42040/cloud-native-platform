#! /bin/bash

## This will install latest stable version of kubectl

echo -e "\n################ Install kubectl ###################\n"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl
