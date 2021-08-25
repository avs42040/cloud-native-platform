## Connect to kafka topics via Druid
#->  kafka.confluent:9092
#->  settings.wekan.settings

#->  quickstart/tutorial/
#->  wikiticker-2015-09-12-sampled.json.gz

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