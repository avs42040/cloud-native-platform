#! /bin/bash

kubectl apply -f cert-issuer-nginx-ingress.yaml
kubectl apply -f certificate.yaml