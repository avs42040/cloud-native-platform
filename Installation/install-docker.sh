#! /bin/bash

export VERSION_STRING="5:19.03.10~3-0~ubuntu-focal" ## define version of docker
export USER="azureuser" ## define username

sudo apt install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
sudo apt update && apt install -y docker-ce=${VERSION_STRING} containerd.io

## Enable using docker without sudo
groupadd docker
sudo usermod -aG docker ${USER} ## add user to docker group
sudo gpasswd -a ${USER} docker
sudo service docker restart
newgrp docker

## See whether you are in docker group
# getent group docker

