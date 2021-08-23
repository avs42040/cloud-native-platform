#! /bin/bash

## Start k3d
echo -e "\n############### Start k3d ################\n"
./k3d/start-k3d-with-traefik.sh

kubectl apply -f headless-service.yaml
kubectl apply -f mongodb-statefulset.yaml

kubectl exec -it mongo-0 -- mongo

################################### Option 1 ########################################
rs.initiate()
var cfg = rs.conf()
cfg.members[0].host="mongo-0.mongo:27017"
rs.reconfig(cfg)
rs.status()
rs.add("mongo-1.mongo:27017")
rs.add("mongo-2.mongo:27017")

################################### Option 2 ########################################
rs.initiate( {
   _id : "rs0",
   members: [
      { _id: 0, host: "mongo-0.mongo:27017" },
      { _id: 1, host: "mongo-1.mongo:27017" },
      { _id: 2, host: "mongo-2.mongo:27017" }
   ]
})
#####################################################################################
kubectl run mongo --rm -it --image mongo -- sh   ## Run mongo shell
mongo 'mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo/?replicaSet=rs0'
mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo --eval 'rs.status()' | grep name  ## one-liner to get names of replicaset

kubectl scale sts mongo --replicas 4
kubectl exec -it mongo-0 -- sh
mongo 'mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo,mongo-3.mongo/?replicaSet=rs0'
mongo mongodb://mongo-0.mongo,mongo-1.mongo,mongo-2.mongo,mongo-3.mongo --eval 'rs.status()' | grep name  ## one-liner to get names of replicaset

############################### Option 1 ##################################### --> this work
kubectl expose pod mongo-0 --port 27017 --target-port 27017 --type LoadBalancer
kubectl expose pod mongo-1 --port 27018 --target-port 27017 --type LoadBalancer
kubectl expose pod mongo-2 --port 27019 --target-port 27017 --type LoadBalancer

mongo mongodb://localhost:27017,localhost:27018,localhost:27019

############################### Option 2 ##################################### --> not work
kubectl apply -f ingress-mongodb.yaml
#mongo mongodb://mongo-0.localhost:8081,mongo-1.localhost:8081,mongo-2.localhost:8081
mongo mongodb://localhost:8081

############################### Option 3 ##################################### --> this work
kubectl port-forward --address 0.0.0.0 pod/mongo-0 27017:27017 &
kubectl port-forward --address 0.0.0.0 pod/mongo-1 27018:27017 &
kubectl port-forward --address 0.0.0.0 pod/mongo-2 27019:27017 &
mongo mongodb://localhost:27017,localhost:27018,localhost:27019