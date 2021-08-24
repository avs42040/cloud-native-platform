#! /bin/bash

export VERSION="1.29.2" ## docker-compose version

echo -e "\n-- Install docker-compose --\n"
sudo curl -L "https://github.com/docker/compose/releases/download/${VERSION}/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose


