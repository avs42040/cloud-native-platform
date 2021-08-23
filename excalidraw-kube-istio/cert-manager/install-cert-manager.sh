#! /bin/bash

kubectl create ns cert-manager
kubectl apply --validate=false \
-f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml
