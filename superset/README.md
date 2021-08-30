# Introduction

Apache Superset is a Data Visualization and Data Exploration Platform. For further detail about apache superset, please refer to https://github.com/apache/superset

We choose to deploy superset because not only due to its popularity, but also it can work together with apache druid that we will also deploy in our demo.

# Install superset exposing with Istio-gateway

This folder contains scripts and configuration files for deploying apache superset in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway will be used to expose superset service via k3d-loadbalancer. We will deploy superset using helm chart provided at https://github.com/apache/superset. Superset will be deployed as deployment in "superset" namespace and expose with services on port 8088

# Folder Structure
## config (folder)
This subfolder contains all yaml-configuration files, which are needed to deploy virtualservice of superset in azure cloud and local machine.

## istio-addons (folder)
This subfolder contains all yaml-configuration files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

## helm (folder)
This subfolder contains all configuration files of superset-helm including values.yaml

## superset-k3d-azure.sh (script)
This script is used to deploy superset in azure cloud environment.
To deploy superset in k3d-cluster in azure cloud, just run this command in this in this folder -->

```bash
./superset-k3d-azure.sh
```

## superset-k3d-local.sh (script)
This script is used to deploy superset in your local environment.
To deploy superset in k3d-cluster in your local machine, just run this command in this in this folder -->

```bash
./superset-k3d-local.sh
```

Ps. For further detail please refer to comments in scripts and configuration files