# Introduction

Confluent Platform is a full-scale data streaming platform that enables you to easily access, store, and manage data as continuous, real-time streams.
For further detail about confluent platform, please refer to https://docs.confluent.io/platform/current/platform.html

Confluent platform is complicate and involves many components to start. Specially together with istio, it is tedious to search and understand how confluent can be deployed in kubernetes together with istio. Therefore, we also decide to demonstrate how confluent can be deployed in k3d-cluster.

We will also show the power of confluent by creating connector using connector binary from debezium project to consume data from mongodb of wekan and store the data in kafka-topics in real-time.


# Install Confluent-platform exposing with Istio-gateway

Since confluent platform is huge, you might need at least 16 Gb RAM to deploy it in kubernetes. The version of confluent we use to install is 6.1.0.0, please feel free to change it in confluent-platform.yaml under folder "config". We use operator to install confluent in namespace "confluent" and use helm-chart to install confluent-operator. We will also install demo from confluent provided from https://github.com/confluentinc/confluent-kubernetes-examples/blob/master/quickstart-deploy/producer-app-data.yaml to show basic function of confluent. We save this file under folder config named producer-app-data.yaml

In case you also install wekan using scripts we provided in wekan folder, you can also run script "add-topics-connectors-source-debezium.sh" or "add-topics-connectors-source-confluent.sh" to create connectors, which will backup data from mongodb of wekan to kafka-topics. Since wekan stores its data in 16 collections, this script will create 16 kafka-topics to save data from each collection. I have created docker image of confluent-connect with relevant connector installed on it and store it in my own private docker repository. If you want to use it in your production environment, please feel free to change it to yours.

To see which component of confluent will be installed, please see them in confluent-platform.yaml under config folder. At the end of installation, user interface of confluent will be available at service of control center at port 9021

Ps. Confluent in this demo can only be run for 30 days, then you need to destroy and recreate it. If you want to run it longer (ex. in your production) please contact confluent team.

This folder contains scripts and configurations files for deploying confluent-platform in k3d-cluster in the cloud enivronment (Azure). Here, Istio-gateway will be used to expose confluent service via k3d-loadbalancer.

# Folder Structure
## config (folder)
This subfolder contains all yaml-configuration files, which are needed to deploy confluent, its virtualservice and a demo.

## istio-addons (folder)
This subfolder contains all yaml-configuration files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

## add-topics-connectors-source-confluent.sh
This script will create kafka-topics to store data from mongodb of wekan and create pipeline to consume data from mongodb using mongodb connector from confluent. If you don't run confluent together with wekan and mongodb, this will not work since there are no mongodb endpoint to connect.

## add-topics-connectors-source-debezium.sh
This script will create kafka-topics to store data from mongodb of wekan and create pipeline to consume data from mongodb using mongodb connector from debezium (we use the one from debezium, because its JSON-data is readable by druid). If you don't run confluent together with wekan and mongodb, this will not work since there are no mongodb endpoint to connect.

## confluent-k3d-azure.sh (script)
This script is used to deploy istio and confluent in azure cloud environment. 
To deploy confluent in k3d-cluster in azure cloud, just run this command in this folder -->

```bash
./confluent-k3d-azure.sh
```

## confluent-k3d-local.sh (script)
This script is used to deploy istio and confluent in your local machine. 
To deploy confluent in k3d-cluster in your local machine, just run this command in this folder -->

```bash
./confluent-k3d-local.sh
```

## Dockerfile
This Dockerfile will use base-image of kafka-connect from confluent and install various kafka-connectors into it. If you want to create your own kafka-connect image with your prefered connector installed, you can use this.

Ps. For further detail please refer to comments in scripts and configuration files

# Some useful command to play with confluent-platform
Scale up kafka instances to 5
```bash
kubectl scale kafka kafka --replicas 5
```

To access kafka instance (number 0)
```bash
kubectl exec -it kafka-0 bash
```

## For the following command, you need to access kafka instance first by run "kubectl exec -it kafka-0 bash"

Create kafka-topic name "test-topic" with 1 partition and 1 replica
```bash
kafka-topics --bootstrap-server kafka:9092 --create --topic test-topic --partitions 1 --replication-factor 1
```

List all Kafka-topics 
```bash
kafka-topics --list --bootstrap-server kafka:9092
```

Describe topic "test-topic" to show Leader, Replicas, Partition, Isr etc.
```bash
kafka-topics --describe --bootstrap-server kafka:9092 --topic test-topic
```

Check number of brokers
```bash
zookeeper-shell zookeeper:2181 ls /kafka-confluent/brokers/ids
```

Run Kafka-consumer listen to topic "test-topic"
```bash
kafka-console-consumer --bootstrap-server kafka:9092 --topic test-topic
```

Run kafka-producer to add message "New message" to topic "test-topic"
```bash
echo \"New message\" | kafka-console-producer --bootstrap-server kafka:9092 --topic test-topic > /dev/null
```

Run kafka-producer to add message to topic "test-topic" via console
```bash
kafka-console-producer --bootstrap-server kafka:9092 --topic test-topic
```

Enable rebalancing of partition between brokers
```bash
kafka-configs --bootstrap-server kafka:9092 --entity-type brokers --entity-default --alter --add-config confluent.balancer.enable=true
```

See information about Kafka connect
```bash
curl -s connect:8083
```

See information about connect plugin
```bash
curl -s connect:8083/connector-plugins
```


