#! /bin/bash

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-accountSettings",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"accountSettings.wekan.accountSettings",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"accountSettings",
     "database":"wekan-sink",
     "collection":"accountSettings",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-announcements",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"activities.wekan.activities",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"announcements",
     "database":"wekan-sink",
     "collection":"announcements",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-activities",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"announcements.wekan.announcements",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"activities",
     "database":"wekan-sink",
     "collection":"activities",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-boards",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"boards.wekan.boards",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"boards",
     "database":"wekan-sink",
     "collection":"boards",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-card_comments",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"cardcomments.wekan.card_comments",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"cardcomments",
     "database":"wekan-sink",
     "collection":"card_comments",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-cards",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"cards.wekan.cards",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"cards",
     "database":"wekan-sink",
     "collection":"cards",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-checklistItems",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"checklistItems.wekan.checklistItems",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"checklistItems",
     "database":"wekan-sink",
     "collection":"checklistItems",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-checklists",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"checklists.wekan.checklists",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"checklists",
     "database":"wekan-sink",
     "collection":"checklists",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-invitation_codes",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"invitationcodes.wekan.invitation_codes",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"invitationcodes",
     "database":"wekan-sink",
     "collection":"invitation_codes",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-lists",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"lists.wekan.lists",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"lists",
     "database":"wekan-sink",
     "collection":"lists",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-meteor-migrations",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"meteormigrations.wekan.meteor-migrations",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"meteormigrations",
     "database":"wekan-sink",
     "collection":"meteor-migrations",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-meteor_accounts_loginServiceConfiguration",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"meteoraccountsloginServiceConfiguration.wekan.meteor_accounts_loginServiceConfiguration",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"meteoraccountsloginServiceConfiguration",
     "database":"wekan-sink",
     "collection":"meteor_accounts_loginServiceConfiguration",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-meteor_oauth_pendingCredentials",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"meteoroauthpendingCredentials.wekan.meteor_oauth_pendingCredentials",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"meteoroauthpendingCredentials",
     "database":"wekan-sink",
     "collection":"meteor_oauth_pendingCredentials",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-presences",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"presences.wekan.presences",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"presences",
     "database":"wekan-sink",
     "collection":"presences",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-settings",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"settings.wekan.settings",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"settings",
     "database":"wekan-sink",
     "collection":"settings",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-swimlanes",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"swimlanes.wekan.swimlanes",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"swimlanes",
     "database":"wekan-sink",
     "collection":"swimlanes",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-unsaved-edits",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"unsavededits.wekan.unsaved-edits",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"unsavededits",
     "database":"wekan-sink",
     "collection":"unsaved-edits",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-sink-wekan-users",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"users.wekan.users",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://root:pass@mongodb-headless.wekan-project.svc.cluster.local:27017",
     "topic.prefix":"users",
     "database":"wekan-sink",
     "collection":"users",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "document.id.strategy.overwrite.existing":true,
     "copy.existing":true
   }}' http://connect-0.connect:8083/connectors -w "\n"











