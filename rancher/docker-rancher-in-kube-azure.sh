#! /bin/bash

#./rancher-docker.sh

## Start k3d
echo -e "\n############### Start k3d ################\n"
../cluster-config/k3d/start-k3d-azure.sh

istioctl install -y --set meshConfig.outboundTrafficPolicy.mode=ALLOW_ANY
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
echo "Wait for istio-addon to start 40 secs"
sleep 40

kubectl create namespace cattle-system
kubectl label namespace cattle-system istio-injection=enabled
kubectl apply -f ../cluster-config/istio-ingress-gateway-azure.yaml
kubectl apply -f service-entry-rancher-azure.yaml
kubectl apply -f ../cluster-config/tls-secret.yaml
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

echo -e "rancher    -->             https://rancher.infologistix-cnc.ddnss.org"
echo -e "kiali      -->             http://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus -->             http://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana    -->             http://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger     -->             http://jaeger.infologistix-cnc.ddnss.org"