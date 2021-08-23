#! /bin/bash

echo -e "\n################ Install k3d ###################\n"
curl -LO "https://github.com/rancher/k3d/releases/download/v4.4.6/k3d-linux-amd64"
sudo chmod +x k3d-linux-amd64
sudo mv ./k3d-linux-amd64 /usr/local/bin/k3d

echo -e "\n################ Install kubectl ###################\n"
curl -LO "https://dl.k8s.io/release/$(curl -L -s https://dl.k8s.io/release/stable.txt)/bin/linux/amd64/kubectl"
sudo chmod +x kubectl
sudo mv ./kubectl /usr/local/bin/kubectl

echo -e "\n################ Install helm ###################\n"
curl -fsSL -o get_helm.sh https://raw.githubusercontent.com/helm/helm/master/scripts/get-helm-3
sudo chmod 700 get_helm.sh
./get_helm.sh

echo -e "\n################ Install istioctl ###################\n"
curl -L https://istio.io/downloadIstio | sh -
sudo chmod +x ./istio-1.10.1/bin/istioctl
sudo mv ./istio-1.10.1/bin/istioctl /usr/local/bin/istioctl
sudo rm -r ./istio-1.10.1
sudo rm get_helm.sh