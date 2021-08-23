//const Kafka = require("kafkajs").Kafka
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

        const consumer = kafka.consumer({"groupId": "group-1"})
        console.log("Connecting.....")
        await consumer.connect()
        console.log("Connected!")
        
        await consumer.subscribe({
            "topic": "users",
            "fromBeginning": true
        })
        
        await consumer.run({
            "eachMessage": async result => {
                console.log(`RVD Msg -${result.message.value}- on partition -${result.partition}- from topic -${result.topic}- from broker -${result.brokers}-`)
            }
        })
 

    }
    catch(ex)
    {
        console.error(`Something bad happened ${ex}`)
    }
    finally{
        
    }


}