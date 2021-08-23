//const Kafka = require("kafkajs").Kafka
const express = require('express'); // use express to let node listen on localhost and not stop
const {Kafka} = require("kafkajs")

run();
async function run(){
    try
    {

        const kafka = new Kafka({
            "clientId": "myapp",
            //"brokers" :['kafka-0.kafka.confluent.svc.cluster.local:9092', 'kafka-1.kafka.confluent.svc.cluster.local:9092', 'kafka-2.kafka.confluent.svc.cluster.local:9092'] // you can put more broker here
            "brokers" :['kafka.confluent.svc.cluster.local:9092']
        })

        const admin = kafka.admin();
        console.log("Connecting.....")
        await admin.connect()
        console.log("Connected!")
        //A-M, N-Z
        await admin.createTopics({
            "topics": [{
                "topic" : "Users",
                "numPartitions": 2
            }]
        })
        console.log("Created Successfully!")
        await admin.disconnect();

    }
    catch(ex)
    {
        console.error(`Something bad happened ${ex}`)
    }
    finally{
        const app = express();
        app.listen(8080, '0.0.0.0'); // let node listen on port 8080
        //process.exit(0);
    }


}