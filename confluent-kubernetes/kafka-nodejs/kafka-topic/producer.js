//const Kafka = require("kafkajs").Kafka
const {Kafka} = require("kafkajs")
const msg = process.argv[2]; // With this, you can input parameter from the command line
run();
async function run(){
    try
    {
         const kafka = new Kafka({
              "clientId": "myapp",
              //"brokers" :['kafka-0.kafka.confluent.svc.cluster.local:9092', 'kafka-1.kafka.confluent.svc.cluster.local:9092', 'kafka-2.kafka.confluent.svc.cluster.local:9092'] // you can put more broker here
              "brokers" :['kafka.confluent.svc.cluster.local:9092']
         })

        const producer = kafka.producer();
        console.log("Connecting.....")
        await producer.connect()
        console.log("Connected!")
        //A-M 0 , N-Z 1 
        const partition = msg[0] < "N" ? 0 : 1;
        const result =  await producer.send({
            "topic": "users",
            "messages": [
                {
                    "value": msg,
                    "partition": partition
                }
            ]
        })

        console.log(`Send Successfully! ${JSON.stringify(result)}`)
        await producer.disconnect();
    }
    catch(ex)
    {
        console.error(`Something bad happened ${ex}`)
    }
    finally{
        process.exit(0); // This will stop node
    }


}