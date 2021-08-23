#! /bin/bash
helm repo add rancher-stable https://releases.rancher.com/server-charts/stable
helm repo update

kubectl apply --validate=false \
-f https://github.com/jetstack/cert-manager/releases/download/v1.4.0/cert-manager.yaml

echo "/n Wait for certmanager to be ready"
sleep 20

kubectl create namespace cattle-system
helm install rancher rancher-stable/rancher --namespace cattle-system --set hostname=infologistix-escalidraw.westeurope.cloudapp.azure.com