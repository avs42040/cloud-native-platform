#! /bin/bash

## Start k3d cluster with loadbalancer mapping cluster port 80 --> 8081 and 443 --> 4430 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" -p "4430:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
kubectl create namespace cattle-system ## create the namespace
kubectl create namespace fleet-system ## create the namespace
kubectl label namespace cattle-system istio-injection=enabled ## Add label "istio-injection=enabled" to the namespace
kubectl label namespace fleet-system istio-injection=enabled ## Add label "istio-injection=enabled" to the namespace
istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

## Deploy cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml 

## Waiting for cert-manager to deploy
kubectl -n cert-manager rollout status deploy cert-manager-webhook

## Deploy rancher
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable && helm repo update ## Add rancher-stable helm repository and update it
helm upgrade --install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.localhost --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=suphanat.aviphan@infologistik.de --wait

## Waiting for rancher to deploy
kubectl -n cattle-system rollout status deploy deployment.apps/rancher
sleep 100
kubectl -n fleet-system rollout status deploy deployment.apps/fleet-controller
sleep 20
kubectl -n fleet-system rollout status deploy deployment.apps/fleet-agent
sleep 10
kubectl -n cattle-system rollout status deploy deployment.apps/rancher-webhook
sleep 20
kubectl -n rancher-operator-system status deploy deployment.apps/rancher-operator












kubectl apply -f ../cluster-config/tls-secret.yaml
#kubectl apply -f rancher-gateway-azure.yaml
#kubectl apply -f ../cluster-config/istio-addons-gateway-azure.yaml

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

#kubectl -n cattle-system port-forward --address 0.0.0.0 deployment.apps/rancher 8443:443 &


echo -e "rancher    -->             https://infologistix-rancher.ddnss.org"
#echo -e "kiali      -->             https://kiali.infologistix-cnc.ddnss.org"
#echo -e "prometheus -->             https://prometheus.infologistix-cnc.ddnss.org"
#echo -e "grafana    -->             https://grafana.infologistix-cnc.ddnss.org"
#echo -e "jaeger     -->             https://jaeger.infologistix-cnc.ddnss.org"
