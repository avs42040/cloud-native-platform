# Install fluentd, elasticsearch and kibana exposing with Istio-gateway

This folder contains scripts and configurations files for deploying fluentd, elasticsearch and kibana in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway will be used to expose fluentd, elasticsearch and kibana service via k3d-loadbalancer.

## Folder Structure
- config (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy fluentd, elasticsearch and kibana.

- istio-addons (folder)

Contain YAML-config files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

- helm-charts-elastic and helm-charts-elastic (folder)

Contain all relevant config-files of helm chart of fluentd, elasticsearch and kibana

- fluentd-k3d-azure.sh (script)

This script is used to deploy fluentd, elasticsearch and kibana in azure cloud environment. 
To deploy fluentd, elasticsearch and kibana in k3d-cluster in azure cloud, just cd into this folder and run

```bash
./fluentd-k3d-azure.sh
```

- fluentd-k3d-local.sh (script)

This script is used to deploy fluentd, elasticsearch and kibana in your local environment.
To deploy fluentd, elasticsearch and kibana in k3d-cluster in your local machine, just cd into this folder and run

```bash
./fluentd-k3d-local.sh
```

Ps. For further detail please refer to comments in scripts and configuration files