#! /bin/bash

export K3D_VERSION="v4.4.6" ## k3d version

echo -e "\n################ Install k3d ###################\n"
curl -LO "https://github.com/rancher/k3d/releases/download/${K3D_VERSION}/k3d-linux-amd64"
sudo chmod +x k3d-linux-amd64
sudo mv ./k3d-linux-amd64 /usr/local/bin/k3d
