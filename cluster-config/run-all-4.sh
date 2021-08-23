#! /bin/bash

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
echo -e "elastic                            -->             https://elastic.infologistix-cnc.ddnss.org"
echo -e "hadoop                             -->             https://hadoop.infologistix-cnc.ddnss.org"
echo -e "zeppelin                           -->             https://zeppelin.infologistix-cnc.ddnss.org"
echo -e "\nkiali                              -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus                         -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana                            -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger                             -->             https://jaeger.infologistix-cnc.ddnss.org"

## kubectl get node -o=jsonpath="{.items[*]['status.capacity.memory']}"

