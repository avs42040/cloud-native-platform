#! /bin/bash

## Start k3d cluster with loadbalancer on port 80 and 443 using Traefik
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6443 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Deploy cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml 

## Waiting for cert-manager to deploy
kubectl -n cert-manager rollout status deploy cert-manager
kubectl -n cert-manager rollout status deploy cert-manager-webhook

## Waiting for traefik to deploy
kubectl -n kube-system rollout status deployment.apps/traefik

kubectl create namespace cattle-system ## We need to extra create cattle-system namespace to install rancher
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable && helm repo update ## Add rancher-stable helm repository and update it

## Deploy rancher using helm in namespace cattle-system. Please specify domain name of Rancher using --set hostname option. 
## In the cloud environment, we will use letsencrypt to generate real certificates (by defining --set ingress.tls.source=letsEncrypt). 
## Please specify you E-Mail using --set letsEncrypt.email option, so that letsencrypt can verify your identity.
helm upgrade --install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.infologistix-cnc.ddnss.org --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=suphanat.aviphan@infologistik.de --wait

## Waiting for rancher to deploy
echo -e "\n -- Waiting for rancher to deploy --\n"
kubectl -n cattle-system rollout status deployment.apps/rancher
sleep 40
kubectl -n fleet-system rollout status deployment.apps/fleet-controller
sleep 15
kubectl -n fleet-system rollout status deployment.apps/fleet-agent
sleep 15
kubectl -n rancher-operator-system rollout status deployment.apps/rancher-operator
sleep 15
kubectl -n cattle-system rollout status deployment.apps/rancher-webhook
echo -e "\n -- Successful !"

echo -e "\n"
echo -e "App                        Link"
echo -e "______________             _________________________________________"
echo -e "rancher    -->             https://rancher.infologistix-cnc.ddnss.org"
