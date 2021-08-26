#! /bin/bash

## Start k3d cluster with loadbalancer on port 80 and 443 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
## create the namespace
kubectl create namespace cattle-system 
kubectl create namespace fleet-system 
kubectl create namespace rancher-operator-system 

## Add label "istio-injection=enabled" to the namespace
kubectl label namespace cattle-system istio-injection=enabled
kubectl label namespace fleet-system istio-injection=enabled
kubectl label namespace rancher-operator-system istio-injection=enabled

istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

## Deploy cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml 

## Waiting for cert-manager to deploy
kubectl -n cert-manager rollout status deploy cert-manager
kubectl -n cert-manager rollout status deploy cert-manager-webhook

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable && helm repo update ## Add rancher-stable helm repository and update it

## Deploy rancher using helm in namespace cattle-system. Please specify domain name of Rancher using --set hostname option. At local machine, we will let Rancher generate its own self-sign certificate
helm upgrade --install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.infologistix-cnc.ddnss.org --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=suphanat.aviphan@infologistix.de --wait

## Waiting for rancher to deploy
echo -e "\n -- Waiting for rancher to deploy --\n"
kubectl -n cattle-system rollout status deployment.apps/rancher
sleep 30
kubectl -n fleet-system rollout status deployment.apps/fleet-controller
sleep 10
kubectl -n fleet-system rollout status deployment.apps/fleet-agent
sleep 10
kubectl -n rancher-operator-system rollout status deployment.apps/rancher-operator
sleep 10
kubectl -n cattle-system rollout status deployment.apps/rancher-webhook
echo -e "\n -- Successful !"

## Create secret containing certificate of each application (We cannot request certificate from letsencrypt many times in a day, therefore we create it once and save it as YAML-config file)
kubectl apply -f ../cluster-config/tls-secret.yaml

kubectl apply -f ./config/rancher-virtualservice-azure.yaml ### Apply Gateway and Virtualservice for rancher
kubectl apply -f ../cluster-config/istio-ingress-gateway-azure.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)
kubectl apply -f ../cluster-config/istio-addons-gateway-azure.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder

echo -e "\n"
echo -e "App                        Link"
echo -e "______________             _____________________________________________"
echo -e "wekan      -->             https://rancher.infologistix-cnc.ddnss.org"
echo -e "kiali      -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana    -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger     -->             https://jaeger.infologistix-cnc.ddnss.org"
