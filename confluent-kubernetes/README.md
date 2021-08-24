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

## https://docs.confluent.io/operator/1.7.0/co-management.html#co-add-connectors
sudo docker build . -t nurihaji/cp-server-connect-operator-custom:6.1.0.0
docker push nurihaji/cp-server-connect-operator-custom:6.1.0.0

kubectl exec -it -n confluent connect-0 -- bash
kubectl logs -n confluent connect-0
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic invitationcodes.wekan.invitation_codes --partitions 1 --replication-factor 1

kubectl exec -it mongodb-primary-0 -n wekan-project -- mongo mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017
kubectl exec -it mongodb-primary-0 -n wekan-project -- bash

confluent-hub install mongodb/kafka-connect-mongodb:1.5.1

curl http://connect-0.connect:8083/connector-plugins | jq
curl http://connect-0.connect:8083/connectors
ls /usr/share/confluent-hub-components


kafka-console-consumer --bootstrap-server kafka:9092 --topic accountSettings.mytestdb.movies --from-beginning   ##<topic>.<db>.<collection>
kubectl exec -it -n confluent kafka-0 -- kafka-console-consumer --bootstrap-server kafka:9092 --topic presences.wekan.presences --from-beginning























# Install Wekan exposing with Istio-gateway

This folder contains scripts and configurations files for deploying wekan in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway will be used to expose wekan service via k3d-loadbalancer.

## Folder Structure
- config (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy wekan.

- istio-addons (folder)

Contain YAML-config files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

- wekan-k3d-azure.sh (script)

This script is used to deploy wekan in azure cloud environment. 
To deploy wekan in k3d-cluster in azure cloud, just cd into this folder and run

```bash
./wekan-k3d-azure.sh
```

- wekan-k3d-local.sh (script)

This script is used to deploy wekan in your local environment.
To deploy wekan in k3d-cluster in your local machine, just cd into this folder and run

```bash
./wekan-k3d-local.sh
```

Ps. For further detail please refer to comments in scripts and configuration files