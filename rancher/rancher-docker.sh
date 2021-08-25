#! /bin/bash

## install rancher using docker
## -p --> defining on which port rancher should be expose
## --restart=unless-stopped --> needed, so you can stop rancher to do a backup or upgrade version of rancher
## --privileged --> needed due to rancher requirement
## --name --> defining name of container

docker run -d --restart=unless-stopped \
-p 8080:80 -p 8443:443 \
--privileged \
--name rancher \
rancher/rancher:latest

echo "Rancher is accessible locally at https://localhost:8443/"
