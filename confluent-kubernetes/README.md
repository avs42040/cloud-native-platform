# Install Confluent-platform exposing with Istio-gateway

This folder contains scripts and configurations files for deploying confluent-platform in k3d-cluster in the cloud enivronment (Azure). Here, Istio-gateway will be used to expose confluent service via k3d-loadbalancer.

## Folder Structure
- config (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy confluent.
-- confluent-platform.yaml --> For creating kafka-components using kafka-operator
-- producer-app-data.yaml --> This script will contain various yaml-files to start kafka-producer-demo, which will run command "kafka-producer-perf-test" to generate data to topic "elastic-0"

- istio-addons (folder)

Contain YAML-config files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

- add-topics-connectors-source-confluent.sh

This script will create kafka-topics to store data from mongodb from wekan app and create pipeline to consume data from mongodb using mongodb connector from confluent. If you don't run confluent together with wekan and mongodb, please feel free to skip this script

- add-topics-connectors-source-debezium.sh

This script will create kafka-topics to store data from mongodb from wekan app and create pipeline to consume data from mongodb using mongodb connector from debezium (we use the one from debezium, because its JSON-data is readable by druid). If you don't run confluent together with wekan and mongodb, please feel free to skip this script

- confluent-k3d-azure.sh (script)

This script is used to deploy istio and confluent in azure cloud environment. 
To deploy confluent in k3d-cluster in azure cloud, just cd into this folder and run

```bash
./confluent-k3d-azure.sh
```

- Dockerfile

This Dockerfile will use base-image of kafka-connect from confluent and install various kafka-connectors into it. If you want to create your own kafka-connect image with your prefered connector installed, you can use this.

Ps. For further detail please refer to comments in scripts and configuration files

## Some useful command to play with confluent-platform

Scale up kafka instances to 5

```bash
kubectl scale kafka kafka --replicas 5
```

To access kafka instance (number 0)

```bash
kubectl exec -it kafka-0 bash
```

- For the following command, you need to access kafka instance first by run "kubectl exec -it kafka-0 bash"

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


