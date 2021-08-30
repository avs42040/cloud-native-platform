# Introduction
Apache Druid is a real-time analytics database designed for fast slice-and-dice analytics ("OLAP" queries) on large data sets. Druid is most often used as a database for powering use cases where real-time ingest, fast query performance, and high uptime are important.

For further detail about apache druid, please refer to https://druid.apache.org/docs/latest/design/index.html

We choose to deploy druid to show how it can ingest data in real time from kafka-topic, which store data from wekan.

# Install Druid exposing with Istio-gateway
This folder contains scripts and configurations files for deploying druid using helm or operator in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway will be used to expose druid service via k3d-loadbalancer. We will deploy druid in druid namespace. Although druid can both be deployed using operator and helm-chart, we prefered for our demo to use helm to install druid, since they can work better with istio. We will use image "apache/druid:0.21.1" to install druid.


# Folder Structure
## config (folder)
This subfolder contains all yaml-configuration files, which are needed to deploy druid with operator and virtualservice in azure cloud and local machine. CustomResourceDefinition (crd) in folder "config" will be used to install druid. These configuration files can be found at https://github.com/druid-io/druid-operator

## istio-addons (folder)
This subfolder contains all yaml-configuration files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

## docker (folder)
This subfolder contains all yaml-configuration files, which are needed to deploy druid in docker.
To deploy druid in docker, just run this command in this in docker folder -->

```bash
sudo docker-compose up -d
```

You will be able to access druid at http://localhost:8888/

## helm (folder)
This subfolder contains all component of druid-helm including values.yaml

## druid-helm-k3d-azure.sh (script)
This script is used to deploy druid in azure cloud environment using helm. 
To deploy druid in k3d-cluster in azure cloud, just run this command in this in this folder -->

```bash
./druid-helm-k3d-azure.sh
```

## druid-helm-k3d-local.sh (script)
This script is used to deploy druid in your local machine using helm. 
To deploy druid in k3d-cluster in your local machine, just run this command in this in this folder -->

```bash
./druid-helm-k3d-local.sh
```

## druid-operator-k3d-azure.sh (script)
This script is used to deploy druid in azure cloud environment using operator. 
To deploy druid in k3d-cluster in azure cloud, jjust run this command in this in this folder -->

```bash
./druid-operator-k3d-azure.sh
```

## druid-operator-k3d-local.sh (script)
This script is used to deploy druid in your local machine using operator. 
To deploy druid in k3d-cluster in your local machine, just run this command in this in this folder -->

```bash
./druid-operator-k3d-local.sh
```

## druid-ingestion.sh (script)
This script is used to generate druid connector to sink data from kafka-topic in confluent. 
!please activate this only if you also deploy confluent with data from wekan in kafka-topics!

Ps. For further detail please refer to comments in scripts and configuration files