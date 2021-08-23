#! /bin/bash

#kubectl delete namespace ingress-nginx

cd ./excalidraw-kube-istio
## Start k3d
echo -e "\n############### Start k3d ################\n"
./k3d/start-k3d-azure.sh

## Install istio
kubectl apply -f ./kompose/namespace.yaml ## namespace excalidraw
kubectl create namespace wekan-project ## namespace wekan-project
kubectl create namespace confluent ## namespace confluent
kubectl create namespace druid
kubectl create namespace superset
./istio.sh
#kubectl label namespace excalidraw istio-injection=enabled
kubectl label namespace wekan-project istio-injection=enabled
kubectl label namespace confluent istio-injection=enabled
kubectl label namespace druid istio-injection=enabled
kubectl label namespace superset istio-injection=enabled

## Set this namespace to default for your Kubernetes context.
kubectl config set-context --current --namespace confluent

## Deploy excalidraw
kubectl apply -f ./kompose/deployment.yaml
kubectl apply -f ./kompose/service.yaml
kubectl apply -f ./kompose/tls-secret.yaml
sleep 1
kubectl apply -f ./kompose/istio-ingress-gateway-azure.yaml
kubectl apply -f ./kompose/excalidraw-virtualservice-azure.yaml
kubectl apply -f ./kompose/istio-addons-gateway-azure.yaml

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

sleep 5

cd ../druid

# kubectl create -f deploy/service_account.yaml
# kubectl create -f deploy/role.yaml
# kubectl create -f deploy/role_binding.yaml
# kubectl create -f deploy/crds/druid.apache.org_druids.yaml
# kubectl create -f deploy/operator.yaml
kubectl apply -f deploy/druid-virtualservice-azure.yaml

helm repo add incubator https://charts.helm.sh/incubator
helm upgrade --install -f ./helm/druid/values.yaml -n druid druid incubator/druid

echo "Wait for druid to start 220 secs"
sleep 220
./druid-ingestion.sh

sleep 5

cd ../superset

helm repo add superset https://apache.github.io/superset
helm upgrade --install -f ./helm/superset/values.yaml -n superset superset superset/superset
kubectl apply -f deploy/superset-virtualservice-azure.yaml

echo "Wait for superset to start 120 secs"
sleep 120

sleep 5

cd ..
#export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_HOST=infologistix-cnc.ddnss.org
#export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export INGRESS_PORT=80
#export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export SECURE_INGRESS_PORT=443
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

echo -e "\nINGRESS_HOST        -> $INGRESS_HOST"
echo -e "INGRESS_PORT        -> $INGRESS_PORT"
echo -e "SECURE_INGRESS_PORT -> $SECURE_INGRESS_PORT"
echo -e "TCP_INGRESS_PORT    -> $TCP_INGRESS_PORT"
echo -e "GATEWAY_URL         -> $GATEWAY_URL\n"

echo -e "excalidraw                         -->             https://excalidraw.infologistix-cnc.ddnss.org"
echo -e "wekan                              -->             https://wekan.infologistix-cnc.ddnss.org"
echo -e "Confluent View Control Center      -->             https://confluent.infologistix-cnc.ddnss.org"
echo -e "rancher                            -->             https://rancher.infologistix-cnc.ddnss.org"
echo -e "druid                              -->             https://druid.infologistix-cnc.ddnss.org"
echo -e "superset                           -->             https://superset.infologistix-cnc.ddnss.org"
echo -e "\nkiali                              -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus                         -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana                            -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger                             -->             https://jaeger.infologistix-cnc.ddnss.org"

## kubectl get node -o=jsonpath="{.items[*]['status.capacity.memory']}"
