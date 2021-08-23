# Install Excalidraw exposing with Nginx-Ingress-Controller

This folder contains scripts and configurations files for deploying excalidraw in k3d-cluster both local and in the cloud (Azure). Here, Nginx-Ingress-Controller will be used to expose Excalidraw service via k3d-loadbalancer.

## Folder Structure
- config (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy excalidraw.

- excalidraw-k3d-azure.sh (script)

This script is used to deploy excalidraw in azure cloud environment. 
To deploy excalidraw in k3d-cluster in azure cloud, just cd into this folder and run

```bash
./excalidraw-k3d-azure.sh
```

- excalidraw-k3d-local.sh (script)

This script is used to deploy excalidraw in your local environment.

Ps. For further detail please refer to comments in scripts and configuration files

