#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
./k3d/start-k3d-azure.sh

## Install cert-manager
kubectl create ns cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml
echo "Wait for cert-manager to start"
sleep 5

## Generate certificate via Letsencrypt
kubectl apply -f ./kompose/namespace.yaml

## Deploy excalidraw
kubectl apply -f ./kompose/deployment.yaml
kubectl apply -f ./kompose/service.yaml

echo -e "\n############### wait for webhook \"validate.nginx.ingress.kubernetes.io\" ################\n"
sleep 30

## Install cert-manager-2
kubectl apply -f ./kompose/cert-issuer-nginx-ingress.yaml
kubectl apply -f ./kompose/certificate.yaml
#kubectl apply -f ./kompose/tls-secret.yaml
sleep 1
kubectl apply -f ./kompose/ingress-nginx.yaml

## Install istio
#./istio.sh
#./kubernetes-dashboard/kubernetes-dashboard.sh

echo -e "rancher    -->             https://20.101.114.139:8443\n"
echo -e "excalidraw -->             https://infologistix-cnc.ddnss.org\n"
echo -e "kiali      -->             http://20.101.114.139:20001\n"
echo -e "prometheus -->             http://20.101.114.139:9090\n"
echo -e "grafana    -->             http://20.101.114.139:3000\n"
echo -e "jaeger     -->             http://20.101.114.139:14250\n"
echo -e "kube-dashboard -->         http://20.101.114.139:8001/api/v1/namespaces/kubernetes-dashboard/services/https:kubernetes-dashboard:/proxy/.\n"