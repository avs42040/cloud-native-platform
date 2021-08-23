#! /bin/bash

docker run -d -p 27017:27017 --name mongodb -v data:/data/db mongo
docker exec -it mongodb sh 

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
db.movies.insert(
    {
        "title": "Avatar",
        "released": 2009,
        "languages": "English"
    }
)
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

################################## Backup and Restore #####################################
## mongodump --out fulldump  ## create a backup in folder fulldump
## mongodump --db test --collection movies --query '{"released":1999}' --out fullldump  ## dump only a test db out and collection movies with released 1999
## mongodump --db test --excludeCollection=games  ## dump all collection except games
## mongodump --db test | mongorestore --host 192.168.1.71 --port 27017   ## copy the content of database
## db.dropDatabase()
## mongorestore
