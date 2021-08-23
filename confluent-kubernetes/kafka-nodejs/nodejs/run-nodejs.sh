#! /bin/bash

sudo docker build . -t nurihaji/node-web-app:latest
docker run -p 49160:8080 -d nurihaji/node-web-app

docker ps
docker logs <container id>
docker exec -it <container id> /bin/bash
curl -i localhost:49160