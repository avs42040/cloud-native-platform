#! /bin/bash

## Start k3d cluster with loadbalancer mapping cluster port 80 --> 8081 and 443 --> 4430 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "8081:80@loadbalancer" -p "4430:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## create namespaces for every services
kubectl create namespace wekan-project
kubectl create namespace confluent
kubectl create namespace druid
kubectl create namespace superset

## Add label "istio-injection=enabled" to every namespaces for every service
kubectl label namespace wekan-project istio-injection=enabled
kubectl label namespace confluent istio-injection=enabled
kubectl label namespace druid istio-injection=enabled
kubectl label namespace superset istio-injection=enabled

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
kubectl apply -f istio-addons-gateway-local.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder
kubectl apply -f istio-ingress-gateway-local.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)

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
kubectl apply -f ./config/wekan-local.yaml ## Apply Deployment and Service of Wekan app
kubectl apply -f ./config/wekan-virtualservice-local.yaml ## Apply Virtualservice for wekan

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

kubectl apply -f ./config/confluent-virtualservice-local.yaml ## Apply Virtualservice for confluent

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

kubectl apply -f config/druid-virtualservice-helm-local.yaml ## Apply Virtualservice for druid

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

kubectl apply -f config/superset-virtualservice-local.yaml ## Apply Virtualservice for superset

################################################################################################################################################################

cd .. ## return back to cloud-native-platform folder

echo -e "\n"
echo -e "App                                            Link"
echo -e "__________________________________             _________________________________"
echo -e "wekan                          -->             https://wekan.localhost:4430"
echo -e "Confluent View Control Center  -->             https://confluent.localhost:4430"
echo -e "druid                          -->             https://druid.localhost:4430"
echo -e "superset                       -->             https://superset.localhost:4430"
echo -e "\nkiali                          -->             http://kiali.localhost:8081"
echo -e "prometheus                     -->             http://prometheus.localhost:8081"
echo -e "grafana                        -->             http://grafana.localhost:8081"
echo -e "jaeger                         -->             http://jaeger.localhost:8081"

## kubectl get node -o=jsonpath="{.items[*]['status.capacity.memory']}"
## druid://druid:druid@druid-broker.druid:8082/druid/v2/sql
