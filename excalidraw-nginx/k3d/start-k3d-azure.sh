#! /bin/bash

k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install ingress-nginx
echo -e "\n############### Install ingress-nginx ################\n"
./install-ingress-nginx.sh
echo -e "Wait for ingress-nginx to start"
sleep 5

echo -e "\n### Start k3d --nginx ingress controller-- at http://infologistix-cnc.ddnss.org/ ###"