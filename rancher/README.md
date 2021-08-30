# Introduction
Rancher is the open-source multi-cluster orchestration platform, allows operations teams deploy, manage and secure enterprise Kubernetes. For further detail about rancher, please refer to https://rancher.com/

In this demo, we will provide both scripts for deploying rancher in k3d-cluster using Traefik (provided by k3d) and istio-gateway. We also provide a script to deploy rancher in docker, but note that it is just for testing purpose. If you install rancher in docker, there are no way to migrate it to Rancher in kubernetes.

# Install Rancher exposing using Traefik/Istio-Gateway
This folder contains scripts and configurations files for deploying rancher in k3d-cluster both local and in the cloud (Azure). Here, Istio-gateway or Traefik will be used to expose rancher service via k3d-loadbalancer, depends on which script you choose. We will deploy rancher using helm-chart and expose it via istio-gateway or Traefik. Since rancher needs tls-certificates to expose its service securely either through self-sign or letsencrypt, we will also deploy cert-manager using helm-chart to let it generate certificates for rancher.

# Folder Structure
## config (folder)
This subfolder contains all yaml-configuration files, which are needed to deploy virtualservice for rancher in azure cloud and local machine.

## istio-addons (folder)
This subfolder contains all yaml-configuration files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

## rancher-docker.sh
This script will install rancher using docker. 

## rancher-k3d-azure-traefik.sh (script)
This script is used to deploy rancher in azure cloud environment using Traefik. 
To deploy rancher in k3d-cluster in azure cloud, just run this command in this in this folder -->

```bash
./rancher-k3d-azure-traefik.sh
```

## rancher-k3d-local-traefik.sh (script)
This script is used to deploy rancher in your local environment using Traefik.
To deploy rancher in k3d-cluster in your local machine, just run this command in this in this folder -->

```bash
./rancher-k3d-local-traefik.sh
```

## rancher-k3d-azure-istio.sh (script)
This script is used to deploy rancher in azure cloud environment using Istio-gateway. 
To deploy rancher in k3d-cluster in azure cloud, just run this command in this in this folder -->

```bash
./rancher-k3d-azure-istio.sh
```

## rancher-k3d-local-istio.sh (script)
This script is used to deploy rancher in your local environment using Istio-gateway.
To deploy rancher in k3d-cluster in your local machine, just run this command in this in this folder -->

```bash
./rancher-k3d-local-istio.sh
```

Ps. For further detail please refer to comments in scripts and configuration files