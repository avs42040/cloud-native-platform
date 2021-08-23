#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
../cluster-config/k3d/start-k3d-no8443.sh

## Install istio
kubectl create namespace fluentd
kubectl label namespace fluentd istio-injection=enabled

istioctl install -y
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
echo "Wait for istio-addon to start 40 secs"
sleep 40

helm repo add fluent https://fluent.github.io/helm-charts
helm repo add elastic https://helm.elastic.co


helm upgrade --install -f ./helm-charts-fluentd/charts/fluentd/values.yaml -n fluentd fluentd ./helm-charts-fluentd/charts/fluentd ##fluent/fluentd
#helm upgrade --install -n fluentd logstash ./helm-charts-elastic/logstash
helm upgrade --install -f ./helm-charts-elastic/elasticsearch/values.yaml -n fluentd elasticsearch ./helm-charts-elastic/elasticsearch ##elastic/elasticsearch 
helm upgrade --install -f ./helm-charts-elastic/kibana/values.yaml -n fluentd kibana ./helm-charts-elastic/kibana ##elastic/kibana


kubectl apply -f ../cluster-config/tls-secret.yaml
kubectl apply -f fluentd-virtualservice-local.yaml
kubectl apply -f ../cluster-config/istio-ingress-gateway-local.yaml
kubectl apply -f ../cluster-config/istio-addons-gateway-local.yaml


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


echo -e "elastic      -->             https://elastic.localhost:4430"
echo -e "kiali        -->             http://kiali.localhost:8081"
echo -e "prometheus   -->             http://prometheus.localhost:8081"
echo -e "grafana      -->             http://grafana.localhost:8081"
echo -e "jaeger       -->             http://jaeger.localhost:8081"

## kubectl port-forward service/kibana-kibana -n fluentd 5601 --address 0.0.0.0
## kubectl logs pod/fluentd-xj78d -n fluentd 