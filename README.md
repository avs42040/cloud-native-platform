# Introduction

Everyone who started to learn kubernetes knows that there are many tutorials for learning kubernetes everywhere, but not many of them provide good example use cases with real application. You might need read a lot of documentation of that application and look for how to deploy that application in kubernetes, which will consume much time (at least in my case).

In this demo, we provide scripts and explanation of how to deploy some real world application like rancher, confluent, druid, superset etc. in k3d kubernetes cluster very quick and start to play around with them !

Istio is an open-source service mesh developed by a collaboration between Google, IBM, and Lyft. With istio, you can connect, monitor, and secure microservices deployed on-premise, in the cloud, or with orchestration platforms like Kubernetes. Since there are only few tutorial and example use-cases using istio out there, we decide to expose and enable communication of services in our demo using istio.

## This demo is good for
- Someone with basic knowledge of linux command, k3d, helm, kubernetes and istio, who want to explore more use cases of them.
- Someone, who want to try out specific applications like confluent, druid, superset, Rancher thorough kubernetes, but still have no idea how to deploy it in kubernetes after searching through the documentation.


# Hardware requirements
We prepare scripts to deploy applications in k3d-cluster in cloud and local machine. Both need at least 8 Gb of RAM for every "single service" and 16 Gb of RAM for confluent service.

## Requirements for running in local machine
You need ubuntu machine with docker, kubectl, helm, k3d and istioctl installed. If you use window, you can use virtual machine with your prefered tool or WSL to run ubuntu machine.

## Requirements for running in the cloud
You need ubuntu machine with docker, kubectl, helm, k3d and istioctl installed. You also need accessible and valid domain name, which can be access through internet and its associated tls-keys and certificates. At least port 80 and 443 are needed to be opened to expose the services.

IMPORTANT!! -> To deploy applications in the cloud, you NEED to adjust all virtualservices and ingress resources to point to your domain name and provide their associated tls-certificates in tls-secret.yaml under folder cluster-config, Otherwise IT WILL NOT WORK!

Ps. If any binary is missing and you want to quickly install it, we prepare scripts in folder "installation" to install them. This folder contain scripts for installing docker-compose, docker, helm, istioctl, k3d and kubectl.

# How to Getting Started
Each subfolder in this folder except "cluster-config" and "installation" folders will be named after the name of the application, which can be deployed using scripts in the folder. You can further read more about how to deploy each appllication in README of each folder

## How to clean up the project
For every application in this demo, you can just run this command to delete the cluster and clear all resources and docker container deploying k3d-cluster.

```bash
k3d cluster delete
```
# Information about scripts
Every application (export confluent) we wrote scripts separately for deploying in cloud and local machine. Their main differences are

## Script for deploying appplications in the cloud
- Services in cloud are exposed at port 80 and 443.
- Services in cloud are exposed under our real domain name "[application-name].infologistix-cnc.ddnss.org".

## Script for deploying appplications in the local machine
- Services in local machine are exposed at port 8081 and 4430, because sometimes port 80 and 443 are not available at local machine.
- Services in local machine are exposed under "[application-name].localhost:8081" or "[application-name].localhost:4430".

# Additional information
- This demo only use k3d to deploy all services in kuberneter, because it comes up with loadbalancer service and easy to be created and destroyed. Please feel free use these scripts as a reference to deploy the services in your own kubernetes cluster, if you have one. 
- We also prepare a script called "run-all.sh" to run our main demo. For more detail, please refer to README in folder cluster-config.
- For every applications exposed using istio-gateway, we will also deployed istio-addons. Istio-addons include Kiali, Grafana, Tracing (Jaeger) and Prometheus. They will help us to collect metrics provided by prometheus and visualize them via Kiali and Grafana.

## Authors

* **Suphanat Aviphan** - IT Consultant - Infologistix GmbH 

If you have other suggestion of how we can improve the demo, plase feel free to reach us.

HAVE FUN !!











# Our main demo

why this demo

what will be deploy in this demo

how component communicate with each other 
- create something in wekan and see how data are transfer to kafka-topic
- confluent we will install connector and create kafka-topic. After that you will see data transfer from mongodb to kafka-topic
- we will also install druid. Druid-MiddleManager will consumer data from kafka-topic using druid-connector we install using script "druid-ingestion.sh" folder druid.
- superset can also ingest the data from druid. With superset, you can explore and visual the data at next level       


cluster-config folder also contains scripts "run-all-azure.sh" and "run-all-local.sh" to run our demo, which we will explain it in the next section.

Its contains

which app is a must, and which one is optional

- excalidraw
- efk-stack
- rancher

- wekan
- confluent
- druid
- superset

## Explain script of our demo

- start deploy k3d without traefik because we will use istio
- create all namespace we need and inject label "istio-injection=enabled" to enable envoy as sidecar container for all pods in that particular namespace. So we can visualize the communication of service via kiali later on
- Install istio-addons (Kiali, Grafana, Prometheus, Jaeger)
- deploy istio-gateway for all services in the demo
- Install wekan, confluent, druid, superset,excalidraw, efk-stack, rancher
- Then you will be able to access the applications with the links described in the run-all script.



run run-all.sh

run the whole process  RAM 64 Gb CPU 8

we provide script to run our demo on both local machine and azure vm. But please do not forget to provide ENOUGH RESOURCE, if you run it on your local machine
If you don't want to deploy specific application in the demo, please comment that part of code out. But we suggest to deploy the whole demo to see how powerful istio is when you deploy many application in the cluster
It might take around 25-30 min to deploy run-all.sh

to clear up demo run k3d cluster delete


