#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
../cluster-config/k3d/start-k3d-no8443.sh

## Install istio
kubectl create namespace wekan-project

istioctl install -y
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
echo "Wait for istio-addon to start 40 secs"
sleep 40

#helm repo add bitnami https://charts.bitnami.com/bitnami
helm repo add stable https://charts.helm.sh/stable
helm repo update
#helm install --name mongodb stable/mongodb --namespace wekan-project --set mongodbRootPassword="pass",mongodbUsername="wekan",mongodbPassword="pass",mongodbDatabase="wekan"

#helm install mongodb bitnami/mongodb --namespace wekan-project --set mongodbRootPassword="pass",mongodbUsername="wekan",mongodbPassword="pass",mongodbDatabase="wekan"
helm install mongodb stable/mongodb -f values.yaml --namespace wekan-project --set mongodbRootPassword="pass",mongodbUsername="wekan",mongodbPassword="pass",mongodbDatabase="wekan"

kubectl apply -f ./wekan/wekan-local.yaml
kubectl apply -f ../cluster-config/tls-secret.yaml
#kubectl apply -f wekan-ingress.yaml
kubectl apply -f ../cluster-config/istio-ingress-gateway-local.yaml
kubectl apply -f ./wekan/wekan-virtualservice-local.yaml
kubectl apply -f ../cluster-config/istio-addons-gateway-local.yaml


echo -e "wekan      -->             https://wekan.localhost:4430"
echo -e "kiali      -->             http://kiali.localhost:8081"
echo -e "prometheus -->             http://prometheus.localhost:8081"
echo -e "grafana    -->             http://grafana.localhost:8081"
echo -e "jaeger     -->             http://jaeger.localhost:8081"

## kubectl exec -it mongodb-primary-0 -n wekan-project -- sh
## mongo mongodb://wekan:pass@mongodb:27017/wekan
## mongo mongodb://root:pass@mongodb:27017