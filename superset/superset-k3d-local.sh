#! /bin/bash

## Start k3d cluster with loadbalancer mapping cluster port 80 --> 8081 and 443 --> 4430 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" -p "4430:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
kubectl create namespace superset ## create the namespace
kubectl label namespace superset istio-injection=enabled ## Add label "istio-injection=enabled" to the namespace
istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

helm repo add superset https://apache.github.io/superset && helm repo update ## Add superset helm repository and update it
helm upgrade --install -f ./helm/superset/values.yaml -n superset superset superset/superset ## Install superset using helm with values.yaml

## Waiting for superset to be deployed
kubectl -n superset rollout status deployment.apps/superset
kubectl -n superset rollout status deployment.apps/superset
kubectl -n superset rollout status deployment.apps/superset-worker

## Create secret containing certificate of each application (We cannot request certificate from letsencrypt many times in a day, therefore we create it once and save it as YAML-config file)
kubectl apply -f ../cluster-config/tls-secret.yaml

kubectl apply -f config/superset-virtualservice-local.yaml ## Apply Virtualservice for superset
kubectl apply -f ../cluster-config/istio-ingress-gateway-local.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)
kubectl apply -f ../cluster-config/istio-addons-gateway-local.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder

echo -e "\n"
echo -e "App                           Link"
echo -e "_________________             ________________________________"
echo -e "superset      -->             https://superset.localhost:4430"
echo -e "kiali         -->             http://kiali.localhost:8081"
echo -e "prometheus    -->             http://prometheus.localhost:8081"
echo -e "grafana       -->             http://grafana.localhost:8081"
echo -e "jaeger        -->             http://jaeger.localhost:8081"
