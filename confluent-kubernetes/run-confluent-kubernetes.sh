#! /bin/bash

## Start k3d cluster with loadbalancer on port 80 and 443 without traefik
## If you want to use traefik, please remove "--k3s-server-arg="--no-deploy=traefik""
echo -e "\n -- Start k3d --\n"
k3d cluster create --api-port 6550 -p "80:80@loadbalancer" -p "443:443@loadbalancer" --k3s-server-arg="--no-deploy=traefik" --agents 1

## Add kubeconfig of this k3d cluster
cp $(k3d kubeconfig write k3s-default) ~/.kube/config

## Install istio
kubectl create namespace confluent ## create confluent namespace
kubectl label namespace confluent istio-injection=enabled ## Add label "istio-injection=enabled" to excalidraw namespace
istioctl install -y ## Install istio
kubectl apply -f istio-addons ## Deploy istio-addons (Kiali, Grafana, Prometheus, Jaeger)
kubectl apply -f istio-addons ## It just need to be applied 2 times ***

## Waiting for ingress-nginx-controller to be deployed
kubectl -n istio-system rollout status deploy kiali
kubectl -n istio-system rollout status deploy grafana

## Add and install the Confluent Operator for Kubernetes Helm repository in confluent namespace.
helm repo add confluentinc https://packages.confluent.io/helm && helm repo update
helm upgrade --install -n confluent confluent-operator confluentinc/confluent-for-kubernetes

## Install all Confluent Platform components. (https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/master/quickstart-deploy/confluent-platform.yaml)
kubectl apply -f ./kompose/confluent-platform.yaml   
## Install a sample producer app and topic (https://raw.githubusercontent.com/confluentinc/confluent-kubernetes-examples/master/quickstart-deploy/producer-app-data.yaml)
kubectl apply -f ./kompose/producer-app-data.yaml

## Create secret contain certificate of each application (We cannot request certificate from letsencrypt many times in a day, therefore we create it once and save it as YAML-config file)
kubectl apply -f ../cluster-config/tls-secret.yaml

kubectl apply -f ../cluster-config/istio-ingress-gateway-azure.yaml ## Deploy Istio-Gateway using config-file from cluster-configuration folder (Apply to all services in the system)
kubectl apply -f confluent-virtualservice-azure.yaml ## Apply Virtualservice for confluent
kubectl apply -f ../cluster-config/istio-addons-gateway-azure.yaml ## Deploy Istio Gateway/Virtualservice/DestinationRule for Istio-addons using config-file from cluster-configuration folder

echo "Wait for confluent to start 450 secs"
sleep 450

./add-topics-connectors-source-debezium.sh
#./add-topics-connectors-source.sh
#./add-topics-connectors-sink.sh

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

## View Control Center --> Set up port forwarding to Control Center web UI from local machine:
#kubectl port-forward controlcenter-0 9021:9021 &

echo -e "Confluent View Control Center      -->             https://confluent.infologistix-cnc.ddnss.org"
echo -e "kiali                              -->             https://kiali.infologistix-cnc.ddnss.org"
echo -e "prometheus                         -->             https://prometheus.infologistix-cnc.ddnss.org"
echo -e "grafana                            -->             https://grafana.infologistix-cnc.ddnss.org"
echo -e "jaeger                             -->             https://jaeger.infologistix-cnc.ddnss.org"

#######################################################################################################################################################################################

## Allow Confluent kubectl plugin for interacting with Confluent for Kubernetes
#sudo tar -xvf confluent-for-kubernetes-2.0.0-20210511/kubectl-plugin/kubectl-confluent-linux-amd64.tar.gz -C /usr/local/bin/  

## Open Confluent Control Center.
#kubectl confluent dashboard controlcenter

## View the Confluent Platform version
#kubectl confluent version

#######################################################################################################################################################################################
# -- kubectl scale kafka kafka --replicas 5 ## scale up kafka pods

## Producer and consumer by nodejs
# -- kubectl exec -it nodejs-0 bash
# -- node producer.js Ali
# -- node consumer.js

# -- kubectl exec -it kafka-0 bash
# -- 
# -- kafka-topics --bootstrap-server kafka:9092 --create --topic invitationcodes.wekan.invitation_codes --partitions 1 --replication-factor 1 ## create topic
# -- kafka-topics --list --bootstrap-server kafka:9092 ## list topics
# -- kafka-topics --describe --bootstrap-server kafka:9092 --topic elastic-0 ## describe topic (Leader, Replicas, Partition, Isr)
# -- echo ruok | nc zookeeper 2181 ## Check status of zookeeper
# -- zookeeper-shell zookeeper:2181 ls /kafka-confluent/brokers/ids ## See how many brokers
# -- zookeeper-shell zookeeper:2181 ls /kafka-confluent/brokers/topics ## See how many topics
# -- kafka-console-consumer --bootstrap-server kafka:9092 --topic elastic-0 --from-beginning ## see message in the topic
# -- echo \"New message\" | kafka-console-producer --bootstrap-server kafka:9092 --topic users > /dev/null ## Send a text "New message" into a topic
# -- kafka-console-producer --bootstrap-server kafka:9092 --topic users ## Send messages to a topic via console
# -- kafka-configs --bootstrap-server kafka:9092 --entity-type brokers --entity-default --alter --add-config confluent.balancer.enable=true ## enable rebalancing of partition between brokers

# -- curl -s connect:8083 ## Information about Kafka connect
# -- curl -s connect:8083/connector-plugins ## Info of Connect plugin
# -- curl -s -X PUT -H "Content-Type: application/json" \
# -- --data '{
# --     "name": "JDBC-Source-Connector",
# --     "config": {
# --     "connector.class": "io.confluent.connect.jdbc.JdbcSourceConnector",
# --     "connection.url": "jdbc:sqlite:/data/my.db",
# --     "table.whitelist": "years",
# --     "mode": "incrementing",
# --     "incrementing.column.name": "id",
# --     "table.types": "TABLE",
# --     "topic.prefix": "shakespeare_"
# --     }
# -- }' http://connect:8083/connectors ## Upload configuration file

