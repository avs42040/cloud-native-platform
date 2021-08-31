# Introduction
Wekan is an open-source and collaborative kanban board application.
For further detail about wekan, please refer to https://wekan.github.io/

We choose to deploy wekan, because it works together with mongodb. Since mongodb is deployed using statefulset, we can use it to explore how to deploy mongodb and how statefulset work in kubernetes. Moreover, it can also personally be used for maintaining a personal todo list, planning your holidays with some friends, or working in a team on your next revolutionary idea, Kanban boards are an unbeatable tool to keep your things organized.

# Install Wekan and Mongodb exposing with Istio-gateway

This folder contains scripts and configuration files for deploying wekan in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway will be used to expose wekan service via k3d-loadbalancer. As mention above, wekan needs mongodb to function properly, therefore our script also contain command to deploy mongodb using helm with relevant configuration configured in values.yaml. Wekan will be deployed as deployment in "wekan-project" namespace exposing port 8080 and mongodb will be deployed as statefulset exposing on port 27017.

# Folder Structure
## config (folder)
This subfolder contains all yaml-configuration files, which are needed to deploy wekan and virtualservice in azure cloud and local machine.

## istio-addons (folder)
This subfolder contains all yaml-configuration files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

## wekan-k3d-azure.sh (script)
This script is used to deploy wekan and mongodb in azure cloud environment.
To deploy wekan in k3d-cluster in azure cloud, just run this command in this folder -->

```bash
./wekan-k3d-azure.sh
```

## wekan-k3d-local.sh (script)
This script is used to deploy wekan and mongodb in your local environment.
To deploy wekan in k3d-cluster in your local machine, just run this command in this folder -->

```bash
./wekan-k3d-local.sh
```

For further detail please refer to comments in scripts and configuration files.