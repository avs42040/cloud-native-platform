#! /bin/bash

docker-compose up -d
docker exec -it mongodb0 sh
docker exec -it mongodb1 sh
docker exec -it mongodb2 sh
mongo --host mongodb://mongodb0
mongo --host mongodb://mongodb1
mongo --host mongodb://mongodb2

rs.status()   ## Get status of replicaset

## Initial a replicaset
rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 0, host: "mongodb0:27017" },
      { _id: 1, host: "mongodb1:27017" },
      { _id: 2, host: "mongodb2:27017" }
   ]
})

mongo 'mongodb://mongodb0,mongodb1,mongodb2/?replicaSet=rs0'    ## Connect to the whole replicaset
rs.printReplicationInfo()    ## Info about replicaset
db.getReplicationInfo()    ## Info about replicaset
rs.conf()   ## see current replicaset configuration

mongo --host mongodb://mongodb2  ## try to access into secondary node directly
rs.secondaryOk()   ## so you can use mongo shell in secondary node
show collections   ## you will see the data has been replicated

docker stop mongodb0   ## generate a failover
mongo --host mongodb://mongodb1  ## connect to only mongodb1
mongo 'mongodb://mongodb0,mongodb1,mongodb2/?replicaSet=rs0'  ## connect to the whole replicaset
rs.status()   ## you will see unavailable status of mongodb0
################################## Basic #####################################
## mongo
## show dbs
## db    ## show which db you use
## show collections
## use mytestdb  ## this will also create a new db
## db.createCollection("movies")   <>   db.movies.drop()
## db.stats()
db.movies.insert(
    {
        "title": "The Matrix",
        "released": 1999,
        "cast": ["Prasit", "Matrix"],
        "review": [
            {
                "reviewer": "Alice",
                "review":"Great movie to watch"
            }
        ]
    }
)
## db.movies.update(
##     {"title": "The Matrix"},
##     {$set: {"languages": "English"}}
## )
## db.movies.update(
##     {"title": "The Matrix"},
##     {$unset: {"languages": ""}}
## )
## db.movies.insert(
##     {
##         "title": "Avatar",
##         "released": 2009,
##         "languages": "English"
##     }
## )
## db.movies.find().pretty()
## db.movies.find({"released": 1999}).pretty()
## db.movies.find({"released": {$gt: 2000}}).pretty()    ## > 2000
## db.movies.find({"released": {$lt: 2000}}).pretty()    ## < 2000
## db.movies.find({}, {"_id": 0, "title": 1}).pretty()    ## dont wanna see id, but only title
## db.movies.count()
## db.movies.count({"released": {$lt: 2000}})  ## count movie which released less than 2000
## db.movies.deleteMany({"languages": "English"})
## db.movies.deleteMany({})  ## delete all documents
## db.movies.drop()   ## delete collection
## db.dropDatabase()    ## delete database

