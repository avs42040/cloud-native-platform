#! /bin/bash

## Start k3d cluster with loadbalancer mapping cluster port 80 --> 8081 and 443 --> 4430 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Deploy cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml 

## Waiting for cert-manager to deploy
kubectl -n cert-manager rollout status deploy cert-manager
kubectl -n cert-manager rollout status deploy cert-manager-webhook

## Waiting for traefik to deploy
kubectl -n kube-system rollout status deployment.apps/traefik

## Deploy rancher
kubectl create namespace cattle-system
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable && helm repo update ## Add rancher-stable helm repository and update it
helm upgrade --install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.infologistix-cnc.ddnss.org --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=suphanat.aviphan@infologistik.de --wait

## Waiting for rancher to deploy
kubectl -n cattle-system rollout status deployment.apps/rancher
sleep 100
kubectl -n fleet-system rollout status deployment.apps/fleet-controller
sleep 20
kubectl -n fleet-system rollout status deployment.apps/fleet-agent
sleep 10
kubectl -n cattle-system rollout status deployment.apps/rancher-webhook
sleep 20
kubectl -n rancher-operator-system rollout status deployment.apps/rancher-operator

echo -e "rancher    -->             https://rancher.infologistix-cnc.ddnss.org"
