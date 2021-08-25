#! /bin/bash

## Start k3d cluster with loadbalancer mapping cluster port 80 --> 8081 and 443 --> 4430 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" -p "4430:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
kubectl create namespace druid ## create excalidraw namespace
#kubectl label namespace druid istio-injection=enabled ## Add label "istio-injection=enabled" to excalidraw namespace (druid-operator is still not working with istio-sidecar, therefore we will not inject the label)
istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

##################################################################################################

# Setup Service Account for druid
kubectl create -f config/service_account.yaml
# Setup RBAC
kubectl create -f config/role.yaml
kubectl create -f config/role_binding.yaml
# Setup the CRD
# Following CRD spec contains schema validation, you can find CRD spec without schema validation at
# config/crds/druid.apache.org_druids_crd.yaml
kubectl create -f config/crds/druid.apache.org_druids.yaml

# deploy the druid-operator
kubectl create -f config/operator.yaml

# Waiting for druid-operator to be deployed
kubectl -n druid rollout status deployment.apps/druid-operator

# deploy single node zookeeper
kubectl apply -f config/tiny-cluster-zk.yaml

# deploy druid cluster spec
kubectl apply -f config/tiny-cluster.yaml

## Waiting for druid to be deployed
sleep 5
kubectl -n druid rollout status statefulset.apps/druid-tiny-cluster-historicals
kubectl -n druid rollout status statefulset.apps/druid-tiny-cluster-brokers
kubectl -n druid rollout status statefulset.apps/druid-tiny-cluster-coordinators
kubectl -n druid rollout status statefulset.apps/druid-tiny-cluster-routers

##################################################################################################

## Create secret containing certificate of each application (We cannot request certificate from letsencrypt many times in a day, therefore we create it once and save it as YAML-config file)
kubectl apply -f ../cluster-config/tls-secret.yaml

kubectl apply -f config/druid-virtualservice-operator-local.yaml ## Apply Virtualservice for druid
kubectl apply -f ../cluster-config/istio-ingress-gateway-local.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)
kubectl apply -f ../cluster-config/istio-addons-gateway-local.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder

echo -e "\n"
echo -e "App                        Link"
echo -e "______________             ________________________________"
echo -e "druid      -->             https://druid.localhost:4430"
echo -e "kiali      -->             http://kiali.localhost:8081"
echo -e "prometheus -->             http://prometheus.localhost:8081"
echo -e "grafana    -->             http://grafana.localhost:8081"
echo -e "jaeger     -->             http://jaeger.localhost:8081"
