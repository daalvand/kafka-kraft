# Kafka Kraft

## Introduction

Kafka Kraft is a project that provides a setup for a multi-node Apache Kafka cluster using Docker Compose.

## Pre-Installation

Ensure Docker and Docker Compose are installed on your machine.

- [Docker](https://www.docker.com/get-started)
- [Docker Compose](https://docs.docker.com/compose/install/)

## Setup Instructions

1. Clone the repository:

   ```bash
   git clone https://github.com/daalvand/kafka-kraft.git
   cd kafka-kraft
   ```

2. Duplicate the environment variable file:

   ```bash
   cp .env.example .env
   ```

3. Modify the `.env` file with your preferred configurations.

4. Execute the startup script:

   ```bash
   ./start.sh
   ```

   This script verifies the existence of the `.env` file, duplicates it from `.env.example` if not found, and starts the Kafka cluster using Docker Compose. If the `CLUSTER_ID` is not set in the `.env` file, it generates a new cluster ID.

## Configuration Details

### `docker-compose.yml`

The primary Docker Compose configuration file for the multi-node Kafka cluster. It outlines three Kafka broker services (`kafka1`, `kafka2`, `kafka3`) with unique hostnames, ports, and environment variables.

## Customization Options

- Tweak the environment variables in the `.env` file to meet your needs.
- Alter the Docker Compose file (`docker-compose.yml`) to modify the Kafka cluster configuration.

## Usage Guidelines

To initiate the Kafka cluster:

```bash
docker compose up -d
```

To halt the Kafka cluster:

```bash
docker compose down
```

## Creating a Kafka Topic

Ensure Kafka is running. Use the following command to create a Kafka topic named `first_topic` with 4 partitions and a replication factor of 2:

```bash
docker compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --create --replication-factor 2 --partitions 4 --topic first_topic
docker compose exec kafka1 kafka-topics --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --describe --topic first_topic
```

## Producing and Consuming Data

You can use the `kafka-console-producer` and `kafka-console-consumer` scripts to produce and consume data.

Here's an example command to produce data to the `first_topic` topic:

```bash
docker compose exec kafka1 kafka-console-producer --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --topic first_topic
```

You can then type your messages into the console, and they will be sent to the `first_topic` topic.

Here's an example command to consume data from the `first_topic` topic:


```bash
docker compose exec kafka1 kafka-console-consumer --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --topic first_topic --from-beginning
```

with consumer group:
```bash
docker compose exec kafka1 kafka-console-consumer --bootstrap-server kafka1:9092,kafka2:9092,kafka3:9092 --topic first_topic --group=my_first_group
```

This command will consume and print all messages from the `first_topic` topic.

## Additional Information

- This project utilizes the official Confluent Kafka Docker image version 7.5.2.
- The `start.sh` script automates the setup process and verifies necessary configurations.

## Used:
[source link](https://levelup.gitconnected.com/kraft-kafka-cluster-with-docker-e79a97d19f2c)