#! /bin/bash

docker run -d -p 27017:27017 --name mongodb -v data:/data/db mongo
docker exec -it mongodb sh 

################################## Authentication #####################################
## use admin
## show users
## show roles  ## list all avaliable role in mongodb
db.createUser(
  {
    user: "myUserAdmin",
    pwd: "abc123", // or cleartext password
    roles: [ { role: "userAdminAnyDatabase", db: "admin" }, "readWriteAnyDatabase" ],
    //mechanisms:[ "SCRAM-SHA-256" ]
  }
)
docker stop $(docker ps -aq)
docker rm $(docker ps -aq)
docker run -d -p 27017:27017 --name mongodb -v data:/data/db mongo --auth  ## Run this again, This will activate authorization mechanisium
docker exec -it mongodb sh 
## mongo -u myUserAdmin -p   ## login with username password
## use admin  ## need to use admin before authenticate
## db.auth("myUserAdmin", "abc123")   ## use to login if you are in mongoshell
## db.changeUserPassword("myUserAdmin", "admin")  ## change user password
#-----------------------------------------------------------------------------
use test
db.createUser(
  {
    user: "myTester",
    pwd:  passwordPrompt(),   // or cleartext password
    roles: [ { role: "readWrite", db: "test" },
             { role: "read", db: "reporting" } ]
  }
)
## mongo -u myTester -p --authenticationDatabase test   ## This is need if that user is not in admin database
