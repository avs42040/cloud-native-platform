#! /bin/bash

sudo docker build ./kafka-topic/. -t nurihaji/kafka-nodejs:latest
docker push nurihaji/kafka-nodejs:latest

#docker run -d --rm --name zookeeper -p 2181:2181 zookeeper

#docker run -d --rm -p 9092:9092 --name kafka \
#-e KAFKA_ZOOKEEPER_CONNECT=localhost:2181 \
#-e KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://localhost:9092 \
#-e KAFKA_OFFSETS_TOPIC_REPLICATION_FACTOR=1 confluentinc/cp-kafka

#docker run -d --rm --name nodejs -p 8080:8080 --net=confluent nurihaji/kafka-nodejs:latest

docker-compose up -d

## Topic "Users" will be created
## Access producer

docker exec -it nodejs bash
node producer.js Ali

## Access producer

docker exec -it nodejs bash
node consumer.js

## You can also start 2 consumer for 1 comsumer group to make it comsumer massages for each partition

