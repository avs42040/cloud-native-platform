#! /bin/bash

## Start k3d cluster with loadbalancer mapping cluster port 80 --> 8081 and 443 --> 4430 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" -p "4430:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
kubectl create namespace wekan-project ## create the namespace
kubectl label namespace wekan-project istio-injection=enabled ## Add label "istio-injection=enabled" to the namespace
istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

## Install Mongodb
helm repo add stable https://charts.helm.sh/stable && helm repo update ## Add stable helm repository and update it

## Install mongodb with 3 replicas using Helm (you can adjust number of replicas by changing it in values.yaml)
helm install mongodb stable/mongodb -f values.yaml --namespace wekan-project --set mongodbRootPassword="pass",mongodbUsername="wekan",mongodbPassword="pass",mongodbDatabase="wekan"

## Waiting for mongodb to deploy
kubectl -n wekan-project rollout status statefulset.apps/mongodb-primary
kubectl -n wekan-project rollout status statefulset.apps/mongodb-arbiter
kubectl -n wekan-project rollout status statefulset.apps/mongodb-secondary

## Create secret containing certificate of each application (We cannot request certificate from letsencrypt many times in a day, therefore we create it once and save it as YAML-config file)
kubectl apply -f ../cluster-config/tls-secret.yaml

kubectl apply -f ./config/wekan-local.yaml ## Apply Deployment and Service of Wekan app 
kubectl apply -f ../cluster-config/istio-ingress-gateway-local.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)
kubectl apply -f ./config/wekan-virtualservice-local.yaml ## Apply Virtualservice for wekan
kubectl apply -f ../cluster-config/istio-addons-gateway-local.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder

## Waiting for wekan to deploy
kubectl -n wekan-project rollout status deployment.apps/wekan

echo -e "\n"
echo -e "App                        Link"
echo -e "______________             ________________________________"
echo -e "wekan      -->             https://wekan.localhost:4430"
echo -e "kiali      -->             http://kiali.localhost:8081"
echo -e "prometheus -->             http://prometheus.localhost:8081"
echo -e "grafana    -->             http://grafana.localhost:8081"
echo -e "jaeger     -->             http://jaeger.localhost:8081"

## kubectl exec -it mongodb-primary-0 -n wekan-project -- sh
## mongo mongodb://wekan:pass@mongodb:27017/wekan
## mongo mongodb://root:pass@mongodb:27017