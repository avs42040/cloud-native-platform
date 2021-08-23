#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
../cluster-config/k3d/start-k3d-no8443.sh

## Install istio
kubectl create namespace druid
kubectl label namespace druid istio-injection=enabled

istioctl install -y
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
kubectl apply -f ../cluster-config/istio-1.10.1/samples/addons
echo "Wait for istio-addon to start 40 secs"
sleep 40

# ##################################################################################################
# 
# # Setup Service Account
# kubectl create -f deploy/service_account.yaml
# # Setup RBAC
# kubectl create -f deploy/role.yaml
# kubectl create -f deploy/role_binding.yaml
# # Setup the CRD
# # Following CRD spec contains schema validation, you can find CRD spec without schema validation at
# # deploy/crds/druid.apache.org_druids_crd.yaml
# kubectl create -f deploy/crds/druid.apache.org_druids.yaml
# 
# # Update the operator manifest to use the druid-operator image name (if you are performing these steps on OSX, see note below)
# #sed -i 's|REPLACE_IMAGE|<druid-operator-image>|g' deploy/operator.yaml
# # On OSX use:
# #sed -i "" 's|REPLACE_IMAGE|<druid-operator-image>|g' deploy/operator.yaml
# 
# # Deploy the druid-operator
# kubectl create -f deploy/operator.yaml
# 
# # Check the deployed druid-operator
# kubectl describe deployment druid-operator
# 
# ##################################################################################################

# deploy single node zookeeper
#kubectl apply -f examples/tiny-cluster-zk.yaml

# deploy druid cluster spec
#kubectl apply -f examples/tiny-cluster.yaml

##################################################################################################
kubectl apply -f ../cluster-config/tls-secret.yaml
kubectl apply -f deploy/druid-virtualservice-local.yaml
kubectl apply -f ../cluster-config/istio-ingress-gateway-local.yaml
kubectl apply -f ../cluster-config/istio-addons-gateway-local.yaml

##################################################################################################
helm repo add incubator https://charts.helm.sh/incubator
helm upgrade --install -f ./helm/druid/values.yaml -n druid druid incubator/druid
##################################################################################################

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


echo -e "druid      -->             https://druid.localhost:4430"
echo -e "kiali      -->             http://kiali.localhost:8081"
echo -e "prometheus -->             http://prometheus.localhost:8081"
echo -e "grafana    -->             http://grafana.localhost:8081"
echo -e "jaeger     -->             http://jaeger.localhost:8081"

## Connect to kafka topics via Druid
#->  kafka.confluent:9092
#->  settings.wekan.settings

#->  quickstart/tutorial/
#->  wikiticker-2015-09-12-sampled.json.gz