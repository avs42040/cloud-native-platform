#! /bin/bash

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic accountSettings.wekan.accountSettings --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic activities.wekan.activities --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic announcements.wekan.announcements --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic boards.wekan.boards --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic cardcomments.wekan.card_comments --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic cards.wekan.cards --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic checklistItems.wekan.checklistItems --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic checklists.wekan.checklists --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic invitationcodes.wekan.invitation_codes --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic lists.wekan.lists --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic meteormigrations.wekan.meteor-migrations --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic meteoraccountsloginServiceConfiguration.wekan.meteor_accounts_loginServiceConfiguration --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic meteoroauthpendingCredentials.wekan.meteor_oauth_pendingCredentials --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic presences.wekan.presences --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic settings.wekan.settings --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic swimlanes.wekan.swimlanes --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic unsavededits.wekan.unsaved-edits --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic users.wekan.users --partitions 1 --replication-factor 3

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-accountSettings",
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
     "database":"wekan",
     "collection":"accountSettings",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-announcements",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"announcements",
     "database":"wekan",
     "collection":"announcements",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-activities",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"activities",
     "database":"wekan",
     "collection":"activities",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-boards",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"boards",
     "database":"wekan",
     "collection":"boards",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-card_comments",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"cardcomments",
     "database":"wekan",
     "collection":"card_comments",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-cards",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"cards",
     "database":"wekan",
     "collection":"cards",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-checklistItems",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"checklistItems",
     "database":"wekan",
     "collection":"checklistItems",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-checklists",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"checklists",
     "database":"wekan",
     "collection":"checklists",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-invitation_codes",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"invitationcodes",
     "database":"wekan",
     "collection":"invitation_codes",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-lists",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"lists",
     "database":"wekan",
     "collection":"lists",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-meteor-migrations",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"meteormigrations",
     "database":"wekan",
     "collection":"meteor-migrations",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-meteor_accounts_loginServiceConfiguration",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"meteoraccountsloginServiceConfiguration",
     "database":"wekan",
     "collection":"meteor_accounts_loginServiceConfiguration",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-meteor_oauth_pendingCredentials",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"meteoroauthpendingCredentials",
     "database":"wekan",
     "collection":"meteor_oauth_pendingCredentials",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-presences",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"presences",
     "database":"wekan",
     "collection":"presences",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-settings",
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

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-swimlanes",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"swimlanes",
     "database":"wekan",
     "collection":"swimlanes",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-unsaved-edits",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"unsavededits",
     "database":"wekan",
     "collection":"unsaved-edits",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-users",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"users",
     "database":"wekan",
     "collection":"users",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"











