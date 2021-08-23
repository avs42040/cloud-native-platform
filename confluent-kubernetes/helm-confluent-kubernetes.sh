#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
../cluster-config/k3d/start-k3d-azure.sh

## Install istio
kubectl create namespace confluent
../cluster-config/istio.sh

## Set this namespace to default for your Kubernetes context.
kubectl config set-context --current --namespace confluent

helm repo add confluentinc-helm https://confluentinc.github.io/cp-helm-charts/
helm repo update
helm upgrade --install -f ./cp-helm-charts/values.yaml -n confluent confluent-oss confluentinc-helm/cp-helm-charts

kubectl apply -f ../cluster-config/tls-secret.yaml

kubectl apply -f ../cluster-config/istio-ingress-gateway-azure.yaml
kubectl apply -f confluent-virtualservice-azure.yaml
kubectl apply -f ../cluster-config/istio-addons-gateway-azure.yaml

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

## View Control Center --> Set up port forwarding to Control Center web UI from local machine:
#kubectl port-forward controlcenter-0 9021:9021 &

echo -e "Confluent View Control Center      -->             https://confluent.infologistix-cnc.ddnss.org"
echo -e "kiali                              -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus                         -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana                            -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger                             -->             https://jaeger.infologistix-cnc.ddnss.org"