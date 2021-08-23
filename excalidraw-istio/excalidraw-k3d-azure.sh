#! /bin/bash

## Start k3d cluster with loadbalancer on port 80 and 443 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
kubectl apply -f ./config/namespace.yaml ## create excalidraw namespace
kubectl label namespace excalidraw istio-injection=enabled ## Add label "istio-injection=enabled" to excalidraw namespace
istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

## Deploy excalidraw
kubectl apply -f ./config/deployment.yaml ## deploy excalidraw
kubectl apply -f ./config/service.yaml ## create service for excalidraw deployment

## Install cert-manager + Generate certificate via Letsencrypt
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml ## deploy cert-manager components

## Waiting for cert-manager to be deployed
kubectl -n cert-manager rollout status deploy cert-manager-webhook

kubectl apply -f ./config/cert-issuer-istio-ingress.yaml ## Create clusterissuer for the certificates
kubectl apply -f ./config/certificate.yaml ## request for the certificates
kubectl apply -f ../cluster-config/istio-ingress-gateway-azure.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)
kubectl apply -f ./config/excalidraw-virtualservice-azure.yaml ## Apply Virtualservice for excalidraw
kubectl apply -f ../cluster-config/istio-addons-gateway-azure.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder
kubectl apply -f ./config/excalidraw-peerauthentication.yaml ## Apply Peerauthentication, this will force communication in excalidraw namespace to use tls

echo -e "\n"
echo -e "App        -->             Link"
echo -e "______________             _____________________________________________"
echo -e "excalidraw -->             https://excalidraw.infologistix-cnc.ddnss.org"
echo -e "kiali      -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana    -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger     -->             https://jaeger.infologistix-cnc.ddnss.org"

