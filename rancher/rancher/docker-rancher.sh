#! /bin/bash

docker run -d --restart=unless-stopped \
-p 8000:80 -p 8443:443 \
--privileged \
rancher/rancher:latest

echo "Rancher is accessiable at https://20.101.114.139:8443/"
echo "Rancher is accessiable at https://localhost:8443/"