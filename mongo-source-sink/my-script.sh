#!/bin/bash

## https://github.com/RWaltersMA
## https://www.youtube.com/watch?v=ZC0sjS4bVpo&t=1854s

docker-compose up -d --build

curl -X GET "http://localhost:8082/topics" -w "\n"
curl -X GET "http://localhost:8083/connectors/" -w "\n"
curl localhost:8083/connector-plugins | jq
docker exec -it mongo1 mongo mongodb://mongo1:27017,mongo2:27017,mongo3:27017/?replicaSet=rs0


docker-compose exec mongo1 /usr/bin/mongo --eval '''if (rs.status()["ok"] == 0) {
    rsconf = {
      _id : "rs0",
      members: [
        { _id : 0, host : "mongo1:27017", priority: 1.0 },
        { _id : 1, host : "mongo2:27017", priority: 0.5 },
        { _id : 2, host : "mongo3:27017", priority: 0.5 }
      ]
    };
    rs.initiate(rsconf);
}

rs.conf();'''

docker-compose exec mongo1 /usr/bin/mongo --eval '''db.runCommand( { dropDatabase: 1 } );''' Stocks

sudo apt install kafkacat

kafkacat -b localhost:9092 -t new_topic -C \
-f '\nKey (%K bytes): %k
Value (%S bytes): %s
Timestamp: %T
Partition: %p
Offset: %o
Headers: %h\n'

kafkacat -b localhost:9092 -t new_topic -P
curl localhost:8083/connector-plugins | jq


curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-source-stockdata",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
     "topic.prefix":"stockdata",
     "database":"Stocks",
     "collection":"StockData",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
   }}' http://localhost:8083/connectors -w "\n"

####################### This can be save into mongodb-source.json #########################
{
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSourceConnector",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
     "topic.prefix":"stockdata",
     "database":"Stocks",
     "collection":"StockData",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000",
     "copy.existing":true
}
############################################################################################

curl -X GET "http://localhost:8082/topics" -w "\n"
curl -X GET "http://localhost:8083/connectors/" -w "\n"

kafkacat -b localhost:9092 -t stockdata.Stocks.StockData -C \
-f '\nKey (%K bytes): %k
Value (%S bytes): %s
Timestamp: %T
Partition: %p
Offset: %o
Headers: %h\n'

pip3 install pymongo
python3 realtime-mongo.py

curl -X POST -H "Content-Type: application/json" --data '
  {"name": "mongo-atlas-sink",
   "config": {
     "tasks.max":"1",
     "connector.class":"com.mongodb.kafka.connect.MongoSinkConnector",
     "topics":"stockdata.Stocks.StockData",
     "key.converter":"org.apache.kafka.connect.json.JsonConverter",
     "key.converter.schemas.enable":false,
     "value.converter":"org.apache.kafka.connect.json.JsonConverter",
     "value.converter.schemas.enable":false,
     "publish.full.document.only":true,
     "connection.uri":"mongodb://mongo1:27017,mongo2:27017,mongo3:27017",
     "topic.prefix":"stockdata",
     "database":"Stocks-sink",
     "collection":"StockData",
     "poll.await.time.ms":"500",
     "poll.max.batch.size":"1000"
   }}' http://localhost:8083/connectors -w "\n"

docker exec -it mongo1 /bin/bash
mongo mongodb://mongo1:27017,mongo2:27017,mongo3:27017
show dbs
use Stocks-sink
show collections
db.StockData.find().pretty()

db.StockData.insert(
    {
        "title": "Avatar",
        "released": 2009,
        "languages": "English"
    }
)

#ccloud connector create --config mongodb-source.json
#ccloud connector list
#ccloud kafka topic consume mongo.Stocks.StocksData