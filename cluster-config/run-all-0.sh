#! /bin/bash

#kubectl delete namespace ingress-nginx

## Start k3d
echo -e "\n############### Start k3d ################\n"
./k3d/start-k3d-azure.sh

## Install istio
kubectl create namespace excalidraw ## namespace excalidraw
kubectl create namespace wekan-project ## namespace wekan-project
kubectl create namespace confluent ## namespace confluent
kubectl create namespace druid
kubectl create namespace superset
kubectl create namespace fluentd
kubectl create namespace hadoop
./istio.sh

kubectl label namespace excalidraw istio-injection=enabled
kubectl label namespace wekan-project istio-injection=enabled
kubectl label namespace confluent istio-injection=enabled
kubectl label namespace druid istio-injection=enabled
kubectl label namespace superset istio-injection=enabled
kubectl label namespace fluentd istio-injection=enabled
kubectl label namespace hadoop istio-injection=enabled

kubectl apply -f tls-secret.yaml
kubectl apply -f istio-addons-gateway-azure.yaml
kubectl apply -f istio-ingress-gateway-azure.yaml

