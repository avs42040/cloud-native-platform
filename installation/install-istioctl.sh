#! /bin/bash

export ISTIO_VERSION="1.10.1" ## istioctl version

echo -e "\n-- Install istioctl --\n"
curl -L https://istio.io/downloadIstio | sh -
sudo chmod +x ./istio-${ISTIO_VERSION}/bin/istioctl
sudo mv ./istio-${ISTIO_VERSION}/bin/istioctl /usr/local/bin/istioctl
sudo rm -r ./istio-${ISTIO_VERSION}
sudo rm get_helm.sh

