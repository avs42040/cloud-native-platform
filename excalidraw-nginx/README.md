# Introduction
Excalidraw is a virtual collaborative whiteboard tool that lets you easily sketch diagrams that have a hand-drawn feel to them. It is easy to deploy and doesn't consume a lot of resource. 
For further detail about excalidraw, please refer to https://github.com/excalidraw/excalidraw


# Install Excalidraw exposing with Nginx-Ingress-Controller

This folder contains scripts and configurations files for deploying excalidraw in k3d-cluster both local and in the cloud (Azure). Here, Nginx-Ingress-Controller will be used to expose Excalidraw service via k3d-loadbalancer. For exposing service from azure cloud, we will also deploy cert-manager to let it generate tls-certification from letsencrypt for excalidraw. We don't need this in case of deploying in local machine, since localhost is already secure. Excalidraw will be deployed as deployment in "excalidraw" namespace exposing port 80

Note: To enable share-function of excalidraw, you need to expose it using tls, otherwise it will not work.

# Folder Structure
## config (folder)

This subfolder contains all yaml-configuration files, which are needed to deploy excalidraw and cert-manager.

## excalidraw-k3d-azure.sh (script)

This script is used to deploy excalidraw in azure cloud environment. 
To deploy excalidraw in k3d-cluster in azure cloud, just run this command in this in this folder -->

```bash
./excalidraw-k3d-azure.sh
```

## excalidraw-k3d-local.sh (script)

This script is used to deploy excalidraw in your local environment.
To deploy excalidraw in k3d-cluster in your local machine, just run this command in this in this folder -->

```bash
./excalidraw-k3d-local.sh
```



Ps. For further detail please refer to comments in scripts and configuration files

