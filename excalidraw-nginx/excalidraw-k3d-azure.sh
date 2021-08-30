#! /bin/bash

## Start k3d cluster with loadbalancer on port 80 and 443 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install ingress-nginx-controller
echo -e "\n-- Install ingress-nginx-controller --\n"
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx && helm repo update  ## Add and update helm repo of ingress-nginx-controller
kubectl create namespace ingress-nginx ## Ingress-nginx-controller need its own namespace. We create one for it.
helm install ingress-nginx ingress-nginx/ingress-nginx --namespace ingress-nginx ## Install ingress-nginx-controlle in ingress-nginx namespace

## Waiting for ingress-nginx-controller to be deployed
kubectl -n ingress-nginx rollout status deploy ingress-nginx-controller

## Deploy excalidraw
kubectl apply -f ./config/namespace.yaml ## create namespace for excalidraw
kubectl apply -f ./config/deployment.yaml ## deploy excalidraw
kubectl apply -f ./config/service.yaml ## create service for excalidraw deployment

## Install cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml ## deploy cert-manager components

## Waiting for cert-manager to be deployed
kubectl -n cert-manager rollout status deploy cert-manager-webhook

kubectl apply -f ./config/cert-issuer-nginx-ingress.yaml ## Create clusterissuer for the certificates
kubectl apply -f ./config/certificate.yaml ## request for the certificates
kubectl apply -f ./config/ingress-azure.yaml ## create ingress-resource to enable excalidraw on cluster ip, port 80

echo -e "\n"
echo -e "App                        Link"
echo -e "______________             _______________________________________________"
echo -e "excalidraw -->             https://excalidraw.infologistix-cnc.ddnss.org\n"
