#! /bin/bash

k3d cluster create --api-port 0.0.0.0:6443 \
-p "0.0.0.0:80:80@loadbalancer" -p "0.0.0.0:443:443@loadbalancer" -p "0.0.0.0:8472:8472@loadbalancer" -p "0.0.0.0:10250:10250@loadbalancer" -p "0.0.0.0:2376:2376@loadbalancer" \
 --agents 1

cp $(k3d kubeconfig write k3s-default) ~/.kube/config
