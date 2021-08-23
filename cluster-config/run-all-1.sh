#! /bin/bash

cd ../hadoop

helm upgrade --install -n hadoop hadoop -f ./helm-hadoop/values.yaml ./helm-hadoop
#helm upgrade --install -n hadoop hadoop $(stable/hadoop/tools/calc_resources.sh 50) -f ./helm-hadoop/values.yaml ./helm-hadoop
helm upgrade --install -n hadoop zeppelin --set hadoop.useConfigMap=true,hadoop.configMapName=hadoop-hadoop ./helm-zeppelin
kubectl apply -f hadoop-virtualservice-azure.yaml

echo "Wait for hadoop to start 120 secs"
sleep 120

