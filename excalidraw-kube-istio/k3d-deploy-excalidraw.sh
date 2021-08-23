#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
../cluster-config/k3d/start-k3d-no8443.sh

## Install istio
kubectl apply -f ./kompose/namespace.yaml
kubectl label namespace excalidraw istio-injection=enabled

istioctl install -y
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
echo "Wait for istio-addon to start 40 secs"
sleep 40

## Install cert-manager
#kubectl create ns cert-manager
#kubectl apply --validate=false \
#-f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml
#echo "Wait for cert-manager to start"
#sleep 5

## Deploy excalidraw
kubectl apply -f ./kompose/deployment.yaml
kubectl apply -f ./kompose/service.yaml

## Generate certificate via Letsencrypt
#kubectl apply -f ./kompose/cert-issuer-nginx-ingress.yaml
#kubectl apply -f ./kompose/certificate.yaml
kubectl apply -f ../cluster-config/tls-secret.yaml
sleep 1
kubectl apply -f ../cluster-config/istio-ingress-gateway-local.yaml
kubectl apply -f ./kompose/excalidraw-virtualservice-local.yaml
kubectl apply -f ../cluster-config/istio-addons-gateway-local.yaml
kubectl apply -f ./kompose/excalidraw-peerauthentication.yaml


#export INGRESS_HOST=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.status.loadBalancer.ingress[0].ip}')
export INGRESS_HOST=localhost
#export INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="http2")].port}')
export INGRESS_PORT=8081
#export SECURE_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="https")].port}')
export SECURE_INGRESS_PORT=4430
export TCP_INGRESS_PORT=$(kubectl -n istio-system get service istio-ingressgateway -o jsonpath='{.spec.ports[?(@.name=="tcp")].port}')
export GATEWAY_URL=$INGRESS_HOST:$INGRESS_PORT

echo -e "\nINGRESS_HOST        -> $INGRESS_HOST"
echo -e "INGRESS_PORT        -> $INGRESS_PORT"
echo -e "SECURE_INGRESS_PORT -> $SECURE_INGRESS_PORT"
echo -e "TCP_INGRESS_PORT    -> $TCP_INGRESS_PORT"
echo -e "GATEWAY_URL         -> $GATEWAY_URL\n"


echo -e "excalidraw -->             https://excalidraw.localhost:4430"
echo -e "kiali      -->             http://kiali.localhost:8081"
echo -e "prometheus -->             http://prometheus.localhost:8081"
echo -e "grafana    -->             http://grafana.localhost:8081"
echo -e "jaeger     -->             http://jaeger.localhost:8081"