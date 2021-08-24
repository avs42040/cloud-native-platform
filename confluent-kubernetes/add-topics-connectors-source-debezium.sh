#! /bin/bash

## Exec into kafka-pod and run command to add kafka-topics to store data from mongodb
## We cannot create topic using yaml-file, if a topic contain "_"
## We cannot change the name of topics, because they need to match with name of collections in mongodb, which are pre-define by wekan

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.accountSettings --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.activities --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.announcements --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.boards --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.card_comments --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.cards --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.checklistItems --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.checklists --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.invitation_codes --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.lists --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.meteor-migrations --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.meteor_accounts_loginServiceConfiguration --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.meteor_oauth_pendingCredentials --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.presences --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.settings --partitions 1 --replication-factor 3

kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.swimlanes --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.unsaved-edits --partitions 1 --replication-factor 3
kubectl exec -it -n confluent kafka-0 -- kafka-topics --bootstrap-server kafka:9092 --create --topic wekan.wekan.users --partitions 1 --replication-factor 3

## Run commands to use connector to let topics consume data from each associated collections in mongodb

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-accountSettings", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.accountSettings" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-announcements", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.announcements" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-activities", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.activities" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-boards", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.boards" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-card_comments", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.card_comments" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-cards", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.cards" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-checklistItems", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.checklistItems" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-checklists", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.checklists" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-invitation_codes", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.invitation_codes" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-lists", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.lists" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-meteor-migrations", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.meteor-migrations" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-meteor_accounts_loginServiceConfiguration", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.meteor_accounts_loginServiceConfiguration" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-meteor_oauth_pendingCredentials", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.meteor_oauth_pendingCredentials" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-presences", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.presences" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-settings", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.settings" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-swimlanes", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.swimlanes" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-unsaved-edits", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.unsaved-edits" 
  }}' http://connect-0.connect:8083/connectors -w "\n"

kubectl exec -it -n confluent connect-0 -- curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-wekan-users", 
   "config": {
     "tasks.max": "1",
     "connector.class": "io.debezium.connector.mongodb.MongoDbConnector", 
     "mongodb.hosts": "rs0/mongodb-headless.wekan-project.svc.cluster.local:27017", 
     "mongodb.name": "wekan",
     "mongodb.user": "root", 
     "mongodb.password": "pass",
     "collection.include.list": "wekan.users" 
  }}' http://connect-0.connect:8083/connectors -w "\n"








