# Introduction
Elasticsearch, Fluentd, and Kibana (EFK) stack is one popular centralized logging solution. When running multiple services and applications on a Kubernetes cluster, a centralized, cluster-level logging stack can help you quickly sort through and analyze the heavy volume of log data produced by your Pods.

# Install EFK-stack exposing with Istio-gateway
As the name suggested, we will deploy 3 applications using helm-charts to run EFK-stack (fluentd, elasticsearch and kibana). This folder contains scripts and configurations files for deploying fluentd, elasticsearch and kibana in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway will be used to expose EFK-stack service via k3d-loadbalancer.

# Folder Structure
## config (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy fluentd, elasticsearch and kibana.


## istio-addons (folder)
This subfolder contains all yaml-configuration files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

## helm-charts-elastic and helm-charts-fluentd (folder)
Contain all relevant configuration files of helm-chart of fluentd, elasticsearch and kibana including values.yaml

## efk-k3d-azure.sh (script)
This script is used to deploy EFK-stack in azure cloud environment. 
To deploy EFK-stack in k3d-cluster in azure cloud, just run this command in this folder -->

```bash
./efk-k3d-azure.sh
```

## efk-k3d-local.sh (script)
This script is used to deploy EFK-stack in your local environment.
To deploy EFK-stack in k3d-cluster in your local machine, just run this command in this folder -->

```bash
./efk-k3d-local.sh
```

Ps. For further detail please refer to comments in scripts and configuration files