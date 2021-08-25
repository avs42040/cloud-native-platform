#! /bin/bash

## Start k3d cluster with loadbalancer on port 80 and 443 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
kubectl create namespace druid ## create excalidraw namespace
kubectl label namespace druid istio-injection=enabled ## Add label "istio-injection=enabled" to excalidraw namespace
istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

helm repo add incubator https://charts.helm.sh/incubator && helm repo update ## Add incubator helm repository and update it
helm upgrade --install -f ./helm/druid/values.yaml -n druid druid incubator/druid ## Install druid using helm with values.yaml in druid namespace

## Waiting for druid to be deployed

kubectl -n druid rollout status deployment.apps/druid-router
kubectl -n druid rollout status deployment.apps/druid-coordinator
kubectl -n druid rollout status deployment.apps/druid-broker

kubectl -n druid rollout status statefulset.apps/druid-historical
kubectl -n druid rollout status statefulset.apps/druid-postgresql
kubectl -n druid rollout status statefulset.apps/druid-zookeeper

## Create secret containing certificate of each application (We cannot request certificate from letsencrypt many times in a day, therefore we create it once and save it as YAML-config file)
kubectl apply -f ../cluster-config/tls-secret.yaml

kubectl apply -f ../cluster-config/istio-ingress-gateway-azure.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)
kubectl apply -f config/druid-virtualservice-helm-azure.yaml ## Apply Virtualservice for druid
kubectl apply -f ../cluster-config/istio-addons-gateway-azure.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder

#./druid-ingestion.sh ## generate druid connector to sink data from kafka-topic in confluent (please activate this only if you also deploy confluent with data from wekan in kafka-topics)

echo -e "\n"
echo -e "App                        Link"
echo -e "______________             _____________________________________________"
echo -e "druid      -->             https://druid.infologistix-cnc.ddnss.org"
echo -e "kiali      -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana    -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger     -->             https://jaeger.infologistix-cnc.ddnss.org"
