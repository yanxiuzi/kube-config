#!/bin/bash

docker run --rm --name kafka_zookeeper_test -d wurstmeister/zookeeper
if [[ $? -ne 0 ]]; then 
    exit 1
fi

zookeeper_ip=`docker inspect --format='{{.NetworkSettings.IPAddress}}' kafka_zookeeper_test`
echo "zookeeper_ip: $zookeeper_ip"

docker run --rm --name kafka_kafka_test \
--env KAFKA_ZOOKEEPER_CONNECT=$zookeeper_ip:2181 \
--env KAFKA_LISTENERS=PLAINTEXT://:9092 \
--env KAFKA_ADVERTISED_LISTENERS=PLAINTEXT://:9092 \
-p 32769:9092 -d wurstmeister/kafka

if [[ $? -ne 0 ]]; then 
    docker stop kafka_zookeeper_test
    exit 1
fi

#add to the container LAN.
docker network create kafka_default || true #may be already exists.
docker network connect kafka_default kafka_zookeeper_test
docker network connect kafka_default kafka_kafka_test

# Wait for kafka service init done, or the topic may be created fail next. 
sleep 3 

#create topic 'test', may be exists
docker exec kafka_kafka_test \
kafka-topics.sh \
--create --topic test \
--partitions 1 \
--replication-factor 1 \
--zookeeper $zookeeper_ip:2181
if [[ $? -ne 0 ]]; then 
    docker stop kafka_zookeeper_test kafka_kafka_test
    exit 1
fi

#inspect topic
docker exec kafka_kafka_test \
kafka-topics.sh --list --zookeeper $zookeeper_ip:2181

docker exec kafka_kafka_test \
kafka-topics.sh --describe --topic test --zookeeper $zookeeper_ip:2181

if [[ $? -ne 0 ]]; then 
    docker stop kafka_zookeeper_test kafka_kafka_test
    exit 1
fi

#open kafka consumer
docker exec kafka_kafka_test \
kafka-console-consumer.sh \
--topic test \
--bootstrap-server localhost:9092


docker stop kafka_zookeeper_test kafka_kafka_test