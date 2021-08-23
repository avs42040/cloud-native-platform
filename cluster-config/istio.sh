#! /bin/bash
istioctl install -y
kubectl apply -f ./istio-1.10.1/samples/addons
kubectl apply -f ./istio-1.10.1/samples/addons
echo "Wait for istio-addon to start 40 secs"
sleep 40

#kubectl port-forward --address 0.0.0.0 svc/kiali -n istio-system 20001 &
#kubectl port-forward --address 0.0.0.0 svc/prometheus -n istio-system 9090 &
#kubectl port-forward --address 0.0.0.0 svc/grafana -n istio-system 3000 &
#kubectl port-forward --address 0.0.0.0 svc/tracing -n istio-system 16686:80 &

#istioctl dashboard kiali &
#istioctl dashboard prometheus &
#istioctl dashboard grafana &
#istioctl dashboard jaeger &