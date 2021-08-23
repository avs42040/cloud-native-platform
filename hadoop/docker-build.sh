#! /bin/bash

sudo docker build . -t nurihaji/hadoop:2.9.0
docker push nurihaji/hadoop:2.9.0
