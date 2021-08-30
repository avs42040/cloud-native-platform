#! /bin/bash

## Start k3d cluster with loadbalancer on port 80 and 443 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## create namespaces for every services
kubectl create namespace excalidraw
kubectl create namespace wekan-project
kubectl create namespace confluent
kubectl create namespace druid
kubectl create namespace superset
kubectl create namespace efk
kubectl create namespace cattle-system 
kubectl create namespace fleet-system 
kubectl create namespace rancher-operator-system

## Add label "istio-injection=enabled" to every namespaces for every service
kubectl label namespace excalidraw istio-injection=enabled
kubectl label namespace wekan-project istio-injection=enabled
kubectl label namespace confluent istio-injection=enabled
kubectl label namespace druid istio-injection=enabled
kubectl label namespace superset istio-injection=enabled
kubectl label namespace efk istio-injection=enabled
kubectl label namespace cattle-system istio-injection=enabled
kubectl label namespace fleet-system istio-injection=enabled
kubectl label namespace rancher-operator-system istio-injection=enabled

################################################################################################################################################################

cd ../cluster-config ## change directory to cluster-config folder

## Install istio
istioctl install -y
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

## Create secret containing certificate of each application (We cannot request certificate from letsencrypt many times in a day, therefore we create it once and save it as YAML-config file)
kubectl apply -f tls-secret.yaml
kubectl apply -f istio-addons-gateway-azure.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder
kubectl apply -f istio-ingress-gateway-azure.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)

################################################################################################################################################################

cd ../excalidraw-istio ## change directory to excalidraw-istio folder

## Deploy excalidraw
kubectl apply -f ./config/deployment.yaml ## deploy excalidraw
kubectl apply -f ./config/service.yaml ## create service for excalidraw deployment
kubectl apply -f ./config/excalidraw-virtualservice-azure.yaml ## Apply Virtualservice for excalidraw
kubectl apply -f ./config/excalidraw-peerauthentication.yaml ## Apply Peerauthentication, this will force communication in excalidraw namespace to use tls

################################################################################################################################################################

cd ../wekan ## change directory to wekan folder

## Install Mongodb
helm repo add stable https://charts.helm.sh/stable && helm repo update ## Add stable helm repository and update it

## Install mongodb with 3 replicas using Helm (you can adjust number of replicas by changing it in values.yaml)
helm install mongodb stable/mongodb -f values.yaml --namespace wekan-project --set mongodbRootPassword="pass",mongodbUsername="wekan",mongodbPassword="pass",mongodbDatabase="wekan"

## Waiting for mongodb to deploy
kubectl -n wekan-project rollout status statefulset.apps/mongodb-primary
kubectl -n wekan-project rollout status statefulset.apps/mongodb-arbiter
kubectl -n wekan-project rollout status statefulset.apps/mongodb-secondary

## Deploy wekan
kubectl apply -f ./config/wekan-azure.yaml ## Apply Deployment and Service of Wekan app
kubectl apply -f ./config/wekan-virtualservice-azure.yaml ## Apply Virtualservice for wekan

## Waiting for wekan to deploy
kubectl -n wekan-project rollout status deployment.apps/wekan

################################################################################################################################################################

cd ../confluent ## change directory to confluent folder

## Add and install the Confluent Operator for Kubernetes Helm repository in confluent namespace.
echo -e "\n -- Install confluent-operator --\n"
helm repo add confluentinc https://packages.confluent.io/helm && helm repo update
helm upgrade --install -n confluent confluent-operator confluentinc/confluent-for-kubernetes

## Waiting for confluent-operator to be deployed
kubectl -n confluent rollout status deployment.apps/confluent-operator

## Install all Confluent Platform components. (https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/master/quickstart-deploy/confluent-platform.yaml)
kubectl apply -f ./config/confluent-platform.yaml   

## Waiting for other confluent component to be deployed
echo -e "\n -- Waiting for kafka-connect and zookeeper to start --\n"
sleep 5
kubectl -n confluent rollout status statefulset.apps/connect
kubectl -n confluent rollout status statefulset.apps/zookeeper
echo -e "\n -- Waiting for kafka to start --\n"
sleep 5
kubectl -n confluent rollout status statefulset.apps/kafka
echo -e "\n -- Waiting for schemaregistry, ksqldb and controlcenter to start --\n"
sleep 5
kubectl -n confluent rollout status statefulset.apps/schemaregistry
kubectl -n confluent rollout status statefulset.apps/ksqldb
kubectl -n confluent rollout status statefulset.apps/controlcenter

## Install a sample producer app and topic (https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/master/quickstart-deploy/producer-app-data.yaml)
kubectl apply -f ./config/producer-app-data.yaml

kubectl apply -f ./config/confluent-virtualservice-azure.yaml ## Apply Virtualservice for confluent

./add-topics-connectors-source-debezium.sh ## Add kafka-connector (source) from debezium to connect with mongodb from wekan app (we use the one from debezium, because its JSON-data is readable by druid)
#./add-topics-connectors-source-confluent.sh ## Add kafka-connector (source) from confluent to connect with mongodb from wekan app

################################################################################################################################################################

cd ../druid ## change directory to druid folder

## Install druid using helm
helm repo add incubator https://charts.helm.sh/incubator && helm repo update ## Add incubator helm repository and update it
helm upgrade --install -f ./helm/druid/values.yaml -n druid druid incubator/druid ## Install druid using helm with values.yaml in druid namespace

## Waiting for druid to be deployed

kubectl -n druid rollout status deployment.apps/druid-router
kubectl -n druid rollout status deployment.apps/druid-coordinator
kubectl -n druid rollout status deployment.apps/druid-broker

kubectl -n druid rollout status statefulset.apps/druid-historical
kubectl -n druid rollout status statefulset.apps/druid-postgresql
kubectl -n druid rollout status statefulset.apps/druid-zookeeper

kubectl apply -f config/druid-virtualservice-helm-azure.yaml ## Apply Virtualservice for druid

./druid-ingestion.sh ## generate druid connector to sink data from kafka-topic in confluent (please activate this only if you also deploy confluent with data from wekan in kafka-topics)

################################################################################################################################################################

cd ../superset ## change directory to superset folder

## Install superset using helm
helm repo add superset https://apache.github.io/superset && helm repo update ## Add superset helm repository and update it
helm upgrade --install -f ./helm/superset/values.yaml -n superset superset superset/superset ## Install superset using helm with values.yaml

## Waiting for superset to be deployed
kubectl -n superset rollout status deployment.apps/superset
kubectl -n superset rollout status deployment.apps/superset
kubectl -n superset rollout status deployment.apps/superset-worker

kubectl apply -f config/superset-virtualservice-azure.yaml ## Apply Virtualservice for superset

################################################################################################################################################################

cd ../efk-stack ## change directory to efk folder

## Add helm repository for fluentd and elasticsearch, then update the repository
helm repo add fluent https://fluent.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
helm repo update

## Install elasticsearch (2 replicas because we deploy 2 nodes) and kibana
helm upgrade --install -n efk kibana elastic/kibana ##./helm-charts-elastic/kibana
helm upgrade --install -n efk --set replicas=2 elasticsearch elastic/elasticsearch ##./helm-charts-elastic/elasticsearch
kubectl -n efk rollout status deployment.apps/kibana-kibana ## Waiting for kibana to be deployed
kubectl -n efk rollout status statefulset.apps/elasticsearch-master ## Waiting for elasticsearch to be deployed

## Install fluentd
helm upgrade --install -f ./helm-charts-fluentd/charts/fluentd/values.yaml -n efk fluentd fluent/fluentd ##./helm-charts-fluentd/charts/fluentd
kubectl -n efk rollout status daemonset.apps/fluentd ## Waiting for fluentd to be deployed

kubectl apply -f ./config/efk-virtualservice-azure.yaml ## Apply Virtualservice for fluentd

################################################################################################################################################################

cd ../rancher ## change directory to rancher folder

## Deploy cert-manager
kubectl apply --validate=false -f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml 

## Waiting for cert-manager to deploy
kubectl -n cert-manager rollout status deploy cert-manager
kubectl -n cert-manager rollout status deploy cert-manager-webhook

helm repo add rancher-stable https://releases.rancher.com/server-charts/stable && helm repo update ## Add rancher-stable helm repository and update it

## Deploy rancher using helm in namespace cattle-system. Please specify domain name of Rancher using --set hostname option. At local machine, we will let Rancher generate its own self-sign certificate
helm upgrade --install rancher rancher-stable/rancher --namespace cattle-system --set hostname=rancher.infologistix-cnc.ddnss.org --set ingress.tls.source=letsEncrypt --set letsEncrypt.email=suphanat.aviphan@infologistix.de --wait

## Waiting for rancher to deploy
echo -e "\n -- Waiting for rancher to deploy --\n"
kubectl -n cattle-system rollout status deployment.apps/rancher
sleep 15
kubectl -n fleet-system rollout status deployment.apps/fleet-controller
sleep 15
kubectl -n fleet-system rollout status deployment.apps/fleet-agent
sleep 15
kubectl -n rancher-operator-system rollout status deployment.apps/rancher-operator
sleep 15
kubectl -n cattle-system rollout status deployment.apps/rancher-webhook
echo -e "\n -- Successful !"

kubectl apply -f ./config/rancher-virtualservice-azure.yaml ### Apply Gateway and Virtualservice for rancher

################################################################################################################################################################

cd .. ## return back to cloud-native-platform folder

echo -e "\n"
echo -e "App                                            Link"
echo -e "__________________________________             _____________________________________________"
echo -e "excalidraw                     -->             https://excalidraw.infologistix-cnc.ddnss.org"
echo -e "wekan                          -->             https://wekan.infologistix-cnc.ddnss.org"
echo -e "Confluent View Control Center  -->             https://confluent.infologistix-cnc.ddnss.org"
echo -e "druid                          -->             https://druid.infologistix-cnc.ddnss.org"
echo -e "superset                       -->             https://superset.infologistix-cnc.ddnss.org"
echo -e "elastic                        -->             https://elastic.infologistix-cnc.ddnss.org"
echo -e "rancher                        -->             https://rancher.infologistix-cnc.ddnss.org"
echo -e "\nkiali                          -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus                     -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana                        -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger                         -->             https://jaeger.infologistix-cnc.ddnss.org"

## kubectl get node -o=jsonpath="{.items[*]['status.capacity.memory']}"
## druid://druid:druid@druid-broker.druid:8082/druid/v2/sql
