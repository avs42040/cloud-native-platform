#! /bin/bash

## Install cert-manager
#kubectl create ns cert-manager
#kubectl apply --validate=false \
#-f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml

#echo "Wait for cert-manager to start"
#sleep 4

## Generate certificate via Letsencrypt
kubectl apply -f ./kompose/namespace.yaml
#kubectl apply -f ./kompose/cert-issuer-nginx-ingress.yaml
#kubectl apply -f ./kompose/certificate.yaml
kubectl apply -f ./kompose/tls-secret.yaml
sleep 1

## Deploy excalidraw
kubectl apply -f ./kompose/deployment.yaml
kubectl apply -f ./kompose/service.yaml
kubectl apply -f ./kompose/ingress-nginx.yaml

## Install istio
./istio.sh

echo -e "excalidraw -->             https://infologistix-escalidraw.westeurope.cloudapp.azure.com/\n"
echo -e "kiali      -->             http://localhost:20001\n"
echo -e "prometheus -->             http://localhost:9090\n"
echo -e "grafana    -->             http://localhost:3000\n"
echo -e "jaeger     -->             http://localhost:14250\n"