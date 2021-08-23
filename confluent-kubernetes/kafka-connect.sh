#! /bin/bash

## https://docs.confluent.io/operator/1.7.0/co-management.html#co-add-connectors
sudo docker build . -t nurihaji/cp-server-connect-operator-custom:6.1.0.0
docker push nurihaji/cp-server-connect-operator-custom:6.1.0.0

kubectl exec -it -n confluent connect-0 -- bash
kubectl logs -n confluent connect-0
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic invitationcodes.wekan.invitation_codes --partitions 1 --replication-factor 1

kubectl exec -it mongodb-primary-0 -n wekan-project -- mongo mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017
kubectl exec -it mongodb-primary-0 -n wekan-project -- bash

confluent-hub install mongodb/kafka-connect-mongodb:1.5.1

curl http://connect-0.connect:8083/connector-plugins | jq
curl http://connect-0.connect:8083/connectors
ls /usr/share/confluent-hub-components

## you need to create topic name "settings.wekan.settings"
curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"settings",
     "database":"wekan",
     "collection":"settings",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"



## you need to create topic name "accountSettings.mytestdb.movies"
   curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-movies",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"accountSettings",
     "database":"mytestdb",
     "collection":"movies",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect:8083/connectors -w "\n"


curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"settings.wekan.settings",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-primary-0.mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"settings",
     "database":"wekan-sink",
     "collection":"settings",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000"
   }}' http://connect:8083/connectors -w "\n"

kafka-console-consumer --bootstrap-server kafka:9092 --topic accountSettings.mytestdb.movies --from-beginning   ##<topic>.<db>.<collection>
kubectl exec -it -n confluent kafka-0 -- kafka-console-consumer --bootstrap-server kafka:9092 --topic presences.wekan.presences --from-beginning
