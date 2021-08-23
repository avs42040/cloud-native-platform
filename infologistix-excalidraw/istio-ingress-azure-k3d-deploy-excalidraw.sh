#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
./k3d/start-k3d-azure-no-nginx.sh

## Install cert-manager
#kubectl create ns cert-manager
#kubectl apply --validate=false \
#-f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml
#echo "Wait for cert-manager to start"
#sleep 5

## Generate certificate via Letsencrypt
kubectl apply -f ./kompose/namespace.yaml

## Deploy excalidraw
kubectl apply -f ./kompose/deployment.yaml
kubectl apply -f ./kompose/service.yaml

## Install cert-manager-2
#kubectl apply -f ./kompose/cert-issuer-nginx-ingress.yaml
#kubectl apply -f ./kompose/certificate.yaml
kubectl apply -f ./kompose/tls-secret.yaml
sleep 1
kubectl apply -f ./kompose/ingress-nginx.yaml

## Install istio
./istio.sh

echo -e "excalidraw -->             https://infologistix-escalidraw.westeurope.cloudapp.azure.com\n"
echo -e "kiali      -->             http://20.56.83.248:20001\n"
echo -e "prometheus -->             http://20.56.83.248:9090\n"
echo -e "grafana    -->             http://20.56.83.248:3000\n"
echo -e "jaeger     -->             http://20.56.83.248:14250\n"