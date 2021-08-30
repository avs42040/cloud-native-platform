#! /bin/bash

## Start k3d cluster with loadbalancer on port 80 and 443 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
kubectl create namespace confluent ## create confluent namespace
kubectl label namespace confluent istio-injection=enabled ## Add label "istio-injection=enabled" to excalidraw namespace
istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

## Add and install the Confluent Operator for Kubernetes Helm repository in confluent namespace.
echo -e "\n -- Install confluent-operator --\n"
helm repo add confluentinc https://packages.confluent.io/helm && helm repo update
helm upgrade --install -n confluent confluent-operator confluentinc/confluent-for-kubernetes

## Waiting for confluent-operator to be deployed
kubectl -n confluent rollout status deployment.apps/confluent-operator

## Install all Confluent Platform components. (Source: https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/master/quickstart-deploy/confluent-platform.yaml)
kubectl apply -f ./config/confluent-platform.yaml   

## Waiting for other confluent component to be deployed
echo -e "\n -- Waiting for kafka-connect and zookeeper to start --\n"
sleep 5
kubectl -n confluent rollout status statefulset.apps/connect
kubectl -n confluent rollout status statefulset.apps/zookeeper
echo -e "\n -- Waiting for kafka to start --\n"
sleep 5
kubectl -n confluent rollout status statefulset.apps/kafka
echo -e "\n -- Waiting for schemaregistry, ksqldb and controlcenter to start --\n"
sleep 5
kubectl -n confluent rollout status statefulset.apps/schemaregistry
kubectl -n confluent rollout status statefulset.apps/ksqldb
kubectl -n confluent rollout status statefulset.apps/controlcenter

## Install a sample producer app and topic (https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/master/quickstart-deploy/producer-app-data.yaml)
kubectl apply -f ./config/producer-app-data.yaml

## Create secret contain certificate of each application (We cannot request certificate from letsencrypt many times in a day, therefore we create it once and save it as YAML-config file)
kubectl apply -f ../cluster-config/tls-secret.yaml

kubectl apply -f ../cluster-config/istio-ingress-gateway-azure.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)
kubectl apply -f ./config/confluent-virtualservice-azure.yaml ## Apply Virtualservice for confluent
kubectl apply -f ../cluster-config/istio-addons-gateway-azure.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder

#./add-topics-connectors-source-debezium.sh ## Add kafka-connector (source) from debezium to connect with mongodb from wekan app (we use the one from debezium, because its JSON-data is readable by druid)
#./add-topics-connectors-source-confluent.sh ## Add kafka-connector (source) from confluent to connect with mongodb from wekan app

echo -e "\n"
echo -e "App                                                Link"
echo -e "_____________________________                      ____________________________________________"
echo -e "Confluent View Control Center      -->             https://confluent.infologistix-cnc.ddnss.org"
echo -e "kiali                              -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus                         -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana                            -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger                             -->             https://jaeger.infologistix-cnc.ddnss.org"



