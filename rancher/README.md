# Install Rancher exposing using Traefik

This folder contains scripts and configurations files for deploying rancher in k3d-cluster both local and in the cloud (Azure). Here, Traefik will be used to expose rancher service via k3d-loadbalancer.

## Folder Structure
- rancher-docker.sh

This script will install rancher using docker. Note that it is just for testing purpose. If you install rancher in docker, there are no way to migrate it to Rancher in kubernetes.

- rancher-k3d-azure.sh (script)

This script is used to deploy rancher in azure cloud environment using Traefik. 
To deploy rancher in k3d-cluster in azure cloud, just cd into rancher folder and run

```bash
./rancher-k3d-azure.sh
```

- rancher-k3d-local.sh (script)

This script is used to deploy rancher in your local environment using Traefik.
To deploy rancher in k3d-cluster in your local machine, just cd into rancher folder and run

```bash
./rancher-k3d-local.sh
```

Ps. For further detail please refer to comments in scripts and configuration files