run the whole process  RAM 32 Gb CPU 4

run single service need 8 Gb RAM
only Confluent need 16 Gb RAM

SSD 32 Gb

If use Window, use VM or WSL

how to Getting Started

how to clean up the project

It might take around 25-30 min to deploy run-all.sh

if you break something, just delete cluster and start it again


Folder structure --> !!!explain usage of each folder (and for what are each application in short form)!!! +++ define link to documention page of that app

how most of the folder and script are constructed

- each folder contain single service --> in each folder contains specific README.md that you can refer to each services
- run-all.sh to run all service
- every service use istio except excalidraw and rancher
- Rancher wil not be deploy together with other services because it use traefik
- traefik and istio cannot use together

## Purpose for this demo

- suit for someone with knowledge in prerequisite
- test your knowledge in kubernetes
- as an example of usage k3d and istio
- someone who want to play with specific app like confluent, rancher, druid etc. but don't know how to install
- logging in kubernetes

## run-all
Its contains
- EFK stack (fluentd, elasticsearch, kibana)
- excalidraw
- wekan
- confluent
- druid
- superset

explain !!!!! pipeline how they all work together !!!! If you have time, explain IN DETAIL WITH PICTURE

## Prerequisite
Knowledge about
- Basic linux command
- Editor such as vim, nano
- kubernetes
- k3d
- helm
- istio
- Kafka/Confluent basic (optional)



## Requirements for running in local machine
Ubuntu machine with -->
- docker
- kubectl
- helm
- k3d
- istioctl

## Requirements for running in the cloud
Accessible domain name and it associated certificates are need to deploy the application.
Ubuntu VM with -->
- docker
- kubectl
- helm
- k3d
- istioctl
At least port 80 and 443 are needed to be opened.

This demo only use k3d to deploy all services on Ubuntu linux distribution. Please free to adjust and use other Linux or Kubernetes distribution

If any binary is missing, you can use our script in folder "Installation" to install the missing binary

If you have other suggestion, or what this demo can be improve plase feel free to reach us


