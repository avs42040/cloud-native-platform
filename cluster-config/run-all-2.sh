#! /bin/bash

cd ../fluentd

helm repo add fluent https://fluent.github.io/helm-charts
helm repo add elastic https://helm.elastic.co
helm upgrade --install -f ./helm-charts-fluentd/charts/fluentd/values.yaml -n fluentd fluentd ./helm-charts-fluentd/charts/fluentd ##fluent/fluentd
#helm upgrade --install -n fluentd logstash ./helm-charts-elastic/logstash
helm upgrade --install -f ./helm-charts-elastic/elasticsearch/values.yaml -n fluentd elasticsearch ./helm-charts-elastic/elasticsearch ##elastic/elasticsearch 
helm upgrade --install -f ./helm-charts-elastic/kibana/values.yaml -n fluentd kibana ./helm-charts-elastic/kibana ##elastic/kibana

kubectl apply -f fluentd-virtualservice-azure.yaml

echo "Wait for fleuntd + elasticsearch + kibana to start 120 secs"
sleep 120
