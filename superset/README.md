# Install superset exposing with Istio-gateway

This folder contains scripts and configurations files for deploying superset in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway will be used to expose superset service via k3d-loadbalancer.

## Folder Structure
- config (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy superset.

- istio-addons (folder)

Contain YAML-config files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

- helm (folder)

This subfolder contains all component of superset-helm including values.yaml

- superset-k3d-azure.sh (script)

This script is used to deploy superset in azure cloud environment.
To deploy superset in k3d-cluster in azure cloud, just cd into this folder and run

```bash
./superset-k3d-azure.sh
```

- superset-k3d-local.sh (script)

This script is used to deploy superset in your local environment.
To deploy superset in k3d-cluster in your local machine, just cd into this folder and run

```bash
./superset-k3d-local.sh
```

Ps. For further detail please refer to comments in scripts and configuration files