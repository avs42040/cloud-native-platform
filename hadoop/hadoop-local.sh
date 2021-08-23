#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
../cluster-config/k3d/start-k3d-no8443.sh

## Install istio
kubectl create namespace hadoop
kubectl label namespace hadoop istio-injection=enabled

istioctl install -y
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
echo "Wait for istio-addon to start 40 secs"
sleep 40

helm upgrade --install -n hadoop hadoop -f ./helm-hadoop/values.yaml ./helm-hadoop
#helm upgrade --install -n hadoop hadoop $(stable/hadoop/tools/calc_resources.sh 50) -f ./helm-hadoop/values.yaml ./helm-hadoop

helm upgrade --install -n hadoop zeppelin --set hadoop.useConfigMap=true,hadoop.configMapName=hadoop-hadoop ./helm-zeppelin

kubectl apply -f ../cluster-config/tls-secret.yaml
kubectl apply -f hadoop-virtualservice-local.yaml
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

echo -e "hadoop        -->             https://hadoop.localhost:4430"
echo -e "zeppelin      -->             https://zeppelin.localhost:4430"
echo -e "kiali         -->             http://kiali.localhost:8081"
echo -e "prometheus    -->             http://prometheus.localhost:8081"
echo -e "grafana       -->             http://grafana.localhost:8081"
echo -e "jaeger        -->             http://jaeger.localhost:8081"

## kubectl port-forward -n hadoop hadoop-hadoop-yarn-rm-0 8088:8088 --address 0.0.0.0
## infologistix-cnc.westeurope.cloudapp.azure.com:8088
## kubectl exec -n hadoop -it hadoop-hadoop-hdfs-nn-0 -- hadoop fs -ls -R /log/  
