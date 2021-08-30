# Explanation

The folder "cluster-config" contains globals configuration files like configuration for deploying istio-gateway, istio-addons, secret containing TLS certificates etc, which are used in many applications . We need this folder to store them, because we don't want to replicate some configuration file like the one for istio-gateway, since they are all the same for every applications.

We will use diferent istio-gateways for exposing applications between cloud vm and local machine, since istio-gateway in the cloud is mainly aimed to expose services using the real domain name and gateways in local machine are aimed to expose services via localhost. We use different istio-gateways, one for applications and one for istio-addons.

Istio-gateway will help us to expose our services via specific domain name ("similar" to kubernetes ingress). It should be deployed in "istio-system" namespace like other istio services. It also enables domain name both with and without TLS. If you want to expose more domain names, you can specify it in yaml-configuration files for istio-gateway.

The yaml-configuration file "tls-secret.yaml" deploys kubernetes instance type "secret" containing all tls-keys and certificates for enabling TLS of our domain name. If you want to other TLS certificates with other domain name, please to define your keys and certificates here. You can apply the certificates to domain names by specifing name of the secrets in yaml-configuration files for istio-gateway. We will apply all secret with certifications in istio-system namespace, so istio-gateway can have access to it. We store all certificates in cluster-config folder, so it is easy to manage.

All of this tls-certificate were requested from letsencrypt prior to the start of this demo, therefore we don't need to request it from letyencrypt every times using cert-manager. It is also not possible to request the same certificates many times from letsencrypt IN A DAY.


# Folder Structure
## istio-addons (folder)
This subfolder contains all yaml-configuration files used to install istio-addons (including Kiali, Prometheus, Grafana, Jaeger)

## istio-addons-gateway-azure.yaml
This yaml-configuration file contain central gateway for all virtualservices of istio-addons and also virtualservices of istio-addons deploying in azure vm. The virtualservices are deployed in istio-system namespace. We will also allow TLS for domain names of istio-addons services using in azure vm too.

## istio-addons-gateway-local.yaml
This yaml-configuration file contain central gateway for all virtualservices of istio-addons and also virtualservices of istio-addons deploying in local machine. The virtualservices are deployed in istio-system namespace. We don't need TLS enable for services exposing via localhost since it is already secure.

## istio-ingress-gateway-azure.yaml
This yaml-configuration file contain central gateway for all virtualservices of other applications deploying in azure vm. It also enables domain name both with and without TLS.

## istio-ingress-gateway-local.yaml
This yaml-configuration file contain central gateway for all virtualservices of other applications deploying in local machine. It also enables domain name both with and without TLS.

## tls-secret.yaml
The yaml-configuration file "tls-secret.yaml" deploys kubernetes instance type "secret" containing all tls-keys and certificates for enabling TLS of our domain name.

Ps. For further detail please refer to comments in scripts and configuration files