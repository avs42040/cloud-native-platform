#! /bin/bash

k3d cluster create --api-port 6550 -p \
"8081:80@loadbalancer" -p "4430:443@loadbalancer" -p "27017:27017@loadbalancer" -p "27018:27018@loadbalancer" -p "27019:27019@loadbalancer" \
--agents 1

cp $(k3d kubeconfig write k3s-default) ~/.kube/config