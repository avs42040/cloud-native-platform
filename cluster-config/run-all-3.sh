#! /bin/bash

cd ../excalidraw-kube-istio

## Deploy excalidraw
kubectl apply -f ./kompose/deployment.yaml
kubectl apply -f ./kompose/service.yaml
kubectl apply -f ./kompose/excalidraw-virtualservice-azure.yaml

sleep 5

cd ../wekan-k8s
## Deploy wekan
helm repo add stable https://charts.helm.sh/stable
helm repo update
helm install mongodb stable/mongodb -f values.yaml --namespace wekan-project --set mongodbRootPassword="pass",mongodbUsername="wekan",mongodbPassword="pass",mongodbDatabase="wekan"
kubectl apply -f ./wekan/wekan-azure.yaml
kubectl apply -f ./wekan/wekan-virtualservice-azure.yaml

sleep 5

cd ../rancher

## Deploy rancher
#./rancher-docker.sh
istioctl install -y --set meshConfig.outboundTrafficPolicy.mode=ALLOW_ANY
kubectl create namespace cattle-system
kubectl label namespace cattle-system istio-injection=enabled
kubectl apply -f service-entry-rancher-azure.yaml

sleep 5

cd ../confluent-kubernetes

## Set this namespace to default for your Kubernetes context.
kubectl config set-context --current --namespace confluent

## Deploy confluent
## Add and install the Confluent for Kubernetes Helm repository.
helm repo add confluentinc https://packages.confluent.io/helm
helm repo update
helm upgrade --install confluent-operator confluentinc/confluent-for-kubernetes
## Install all Confluent Platform components. (https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/master/quickstart-deploy/confluent-platform.yaml)
kubectl apply -f ./kompose/confluent-platform.yaml   
## Install a sample producer app and topic (https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/master/quickstart-deploy/producer-app-data.yaml)
kubectl apply -f ./kompose/producer-app-data.yaml
#kubectl apply -f ./kompose/kafka-topic.yaml
kubectl apply -f ./nodejs-producer.yaml
kubectl apply -f ./confluent-virtualservice-azure.yaml

echo "Wait for confluent to start 450 secs"
sleep 450

./add-topics-connectors-source-debezium.sh
#./add-topics-connectors-source-new.sh
#./add-topics-connectors-sink.sh