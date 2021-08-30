## This dockerfile is used to create docker image from confluentinc/cp-server-connect-operator as base-image. 
## Here you can adjust env variable of kafka-connect and install connectors.

FROM confluentinc/cp-server-connect-operator:6.1.0.0
USER root

## Define environment variables of connector

## Where should connector binary be stored
ENV CONNECT_PLUGIN_PATH="/usr/share/java,/usr/share/confluent-hub-components" 
ENV CONNECT_KEY_CONVERTER: io.confluent.connect.avro.AvroConverter
## Name of service of Schemaregistry
ENV CONNECT_KEY_CONVERTER_SCHEMA_REGISTRY_URL: 'http://schemaregistry:8081'
ENV CONNECT_VALUE_CONVERTER: io.confluent.connect.avro.AvroConverter
## Name of service of Schemaregistry
ENV CONNECT_VALUE_CONVERTER_SCHEMA_REGISTRY_URL: 'http://schemaregistry:8081'
ENV CONNECT_INTERNAL_KEY_CONVERTER: "org.apache.kafka.connect.json.JsonConverter"
ENV CONNECT_INTERNAL_VALUE_CONVERTER: "org.apache.kafka.connect.json.JsonConverter"
ENV CONNECT_LOG4J_ROOT_LOGLEVEL: "INFO"
ENV CONNECT_LOG4J_LOGGERS: "org.apache.kafka.connect.runtime.rest=WARN,org.reflections=ERROR,com.mongodb.kafka=DEBUG"
ENV CLASSPATH: "/usr/share/java/monitoring-interceptors/monitoring-interceptors-6.1.0.jar"
ENV CONNECT_PRODUCER_INTERCEPTOR_CLASSES: "io.confluent.monitoring.clients.interceptor.MonitoringProducerInterceptor"
ENV CONNECT_CONSUMER_INTERCEPTOR_CLASSES: "io.confluent.monitoring.clients.interceptor.MonitoringConsumerInterceptor"

## Installing connectors to kafka-connect
RUN confluent-hub install --no-prompt mongodb/kafka-connect-mongodb:latest
RUN confluent-hub install --no-prompt debezium/debezium-connector-mongodb:1.6.0
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-datagen:0.5.0
RUN confluent-hub install --no-prompt debezium/debezium-connector-postgresql:1.6.0
RUN confluent-hub install --no-prompt debezium/debezium-connector-mysql:1.6.0
RUN confluent-hub install --no-prompt debezium/debezium-connector-sqlserver:1.6.0
RUN confluent-hub install --no-prompt snowflakeinc/snowflake-kafka-connector:1.5.5
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-azure-blob-storage:1.6.2
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-elasticsearch:11.0.6
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-jdbc:10.2.0
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-aws-redshift:1.1.0
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-influxdb:1.2.1
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-netezza:1.0.1
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-oracle-cdc:1.2.1
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-hbase:1.0.9
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs3:1.1.2
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-teradata:1.0.4
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-azure-data-lake-gen1-storage:1.6.2
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-cassandra:2.0.0
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-github:1.0.4
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-avro-converter:6.2.0
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-hdfs3-source:1.4.6
RUN confluent-hub install --no-prompt confluentinc/kafka-connect-json-schema-converter:6.2.0
RUN confluent-hub install --no-prompt jcustenborder/kafka-connect-redis:0.0.2.13
RUN confluent-hub install --no-prompt neo4j/kafka-connect-neo4j:1.0.9

## Change authority back to normal user
USER 1001