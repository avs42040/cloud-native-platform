#! /bin/bash

docker run -d --restart=unless-stopped \
-p 8000:80 -p 4443:443 \
--privileged \
--name rancher \
rancher/rancher:latest

echo "Rancher is accessiable at https://localhost:4443/"
