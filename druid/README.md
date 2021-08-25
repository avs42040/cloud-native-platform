# Install Druid exposing with Istio-gateway

This folder contains scripts and configurations files for deploying druid in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway will be used to expose druid service via k3d-loadbalancer.

## Folder Structure
- config (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy druid in kubernetes.

- docker (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy druid in docker.
To deploy druid in docker, just cd into this docker folder and run

```bash
sudo docker-compose up -d
```

You will be able to access docker at http://localhost:8888/

- helm (folder)

This subfolder contains all component of druid-helm including values.yaml

- istio-addons (folder)

Contain YAML-config files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

- druid-helm-k3d-azure.sh (script)

This script is used to deploy druid in azure cloud environment using helm. 
To deploy druid in k3d-cluster in azure cloud, just cd into this druid folder and run

```bash
./druid-helm-k3d-azure.sh
```

- druid-helm-k3d-local.sh (script)

This script is used to deploy druid in your local machine using helm. 
To deploy druid in k3d-cluster in your local machine, just cd into this druid folder and run

```bash
./druid-helm-k3d-local.sh
```

- druid-operator-k3d-azure.sh (script)

This script is used to deploy druid in azure cloud environment using operator. 
To deploy druid in k3d-cluster in azure cloud, just cd into this druid folder and run

```bash
./druid-operator-k3d-azure.sh
```

- druid-operator-k3d-local.sh (script)

This script is used to deploy druid in your local machine using operator. 
To deploy druid in k3d-cluster in your local machine, just cd into this druid folder and run

```bash
./druid-operator-k3d-local.sh
```

- druid-ingestion.sh (script)

This script is used to generate druid connector to sink data from kafka-topic in confluent. 
!please activate this only if you also deploy confluent with data from wekan in kafka-topics!

Ps. For further detail please refer to comments in scripts and configuration files