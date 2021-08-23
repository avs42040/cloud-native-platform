#! /bin/bash

k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" -p "4430:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

cp $(k3d kubeconfig write k3s-default) ~/.kube/config