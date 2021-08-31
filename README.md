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
You need ubuntu machine with 
- docker
- kubectl 
- helm
- k3d
- istioctl 
installed. You also need accessible and valid domain name, which can be accessed through internet and its associated tls-keys and certificates. At least port 80 and 443 are needed to be opened to expose the services.

IMPORTANT!! -> To deploy applications in the cloud, you NEED to adjust all virtualservices and ingress resources to point to your domain name and provide their associated tls-certificates in tls-secret.yaml under folder cluster-config, Otherwise IT WILL NOT WORK!

Ps. If any binary is missing and you want to quickly install it, we prepare scripts in folder "installation" to install them. This folder contain scripts for installing docker-compose, docker, helm, istioctl, k3d and kubectl.

# How to Getting Started
Each subfolder in this folder except "cluster-config" and "installation" folders will be named after the name of the application, which can be deployed using scripts in the folder. You can further read more about how to deploy each appllication in README of each folder

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

We have created scripts (run-demo-azure.sh, run-demo-local.sh, run-all-azure.sh and run-all-local.sh) to deploy our demo. run-demo-azure.sh and run-demo-local.sh scripts are used to deploy only our demo, which including wekan, confluent, druid and superset. run-all-azure.sh and run-all-local.sh are used to run every applications we provided, also including excalidraw, rancher and efk-stack. You will be able to see power of istio together with its addons kiali, which can help us to visualize communications between services. You can choose to run only our demo or every application.

## why this demo and how the components all work together
We choose to deploy
- wekan
- confluent
- druid
- superset

together for our demo, because they can work together.

Since wekan storage its data in collections of mongodb and confluent has kafka-connect, it is possible to use kafka-connect to consume the data from mongodb and storage them in kafka-topic in real-time. We will also create kafka-topics and install connector to use it to bind mongodb collection together with kafka-topics, so the data can be started to transfer. The data from each collection will be stored in each kafka-topic. You can test it by creating some instances in wekan and see which data is produced and transfered.

Apache Druid also has its connector to consume data from kafka-topic. Druid-MiddleManager will consumer data from kafka-topic using druid-connector we install using script "druid-ingestion.sh" folder druid in real-time. You can confirm its connectivity by either look in the druid database or in kiali, in which it should show connecting line between druid middlemanager and kafka-instance.

At last, we can manually ingest data from druid to apache superset instance, which we will also deployed in this demo. At this point, if you create something in wekan, the data should be replicated through the whole pipeline upto superset within 10 second or less.

# Hardware requirements
The requirements are similar as deploying other application. This demo need at least 32 Gb of RAM and about 20 minutes for the deployment. If you wanted to deploy every applications, you need 64 Gb of RAM and about 35 minutes.

# To run this demo
There are scripts run-demo-azure.sh, run-demo-local.sh, run-all-azure.sh and run-all-local.sh.

### run-demo-azure.sh (script)
This script is used to start the demo in azure vm including wekan, confluent, druid and superset. We explain each step using comments in the script.
To deploy the demo in k3d-cluster in azure vm, just run this command in this folder -->

```bash
./run-demo-azure.sh
```

### run-demo-local.sh (script)
This script is used to start the demo in local machine including wekan, confluent, druid and superset. We explain each step using comments in the script.
To deploy the demo in k3d-cluster in local machine, just run this command in this folder -->

```bash
./run-demo-local.sh
```

### run-all-azure.sh (script)
This script is used to start every applications in azure vm including wekan, confluent, druid, superset, excalidraw, rancher and efk-stack. We explain each step using comments in the script.
To deploy every applications in k3d-cluster in azure vm, just run this command in this folder -->

```bash
./run-all-azure.sh
```

### run-all-local.sh (script)
This script is used to start every applications in local machine including wekan, confluent, druid, superset, excalidraw, rancher and efk-stack. We explain each step using comments in the script.
To deploy every applications in k3d-cluster in azure vm, just run this command in this folder -->

```bash
./run-all-local.sh
```

## How to clean up the project
For every application in this demo, you can just run this command to delete the cluster and clear all resources and docker container deploying k3d-cluster.

```bash
k3d cluster delete
```
