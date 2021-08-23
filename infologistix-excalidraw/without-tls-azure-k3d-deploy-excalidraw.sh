#! /bin/bash

## Install cert-manager
#kubectl create ns cert-manager
#kubectl apply --validate=false \
#-f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml

#echo "Wait for cert-manager to start"
#sleep 4

## Start k3d
echo -e "\n############### Start k3d ################\n"
./k3d/start-k3d-azure.sh

## Generate certificate via Letsencrypt
kubectl apply -f ./kompose/namespace.yaml
#kubectl apply -f ./kompose/cert-issuer-nginx-ingress.yaml
#kubectl apply -f ./kompose/certificate.yaml
sleep 1

## Deploy excalidraw
kubectl apply -f ./kompose/deployment.yaml
kubectl apply -f ./kompose/service.yaml

echo -e "\n############### wait for webhook \"validate.nginx.ingress.kubernetes.io\" ################\n"
sleep 30
kubectl apply -f ./kompose/ingress-nginx-no-tls.yaml

echo -e "excalidraw without                 -->             http://infologistix-escalidraw.westeurope.cloudapp.azure.com\n"
echo -e "excalidraw with (fake-certificate) -->             https://infologistix-escalidraw.westeurope.cloudapp.azure.com\n"
