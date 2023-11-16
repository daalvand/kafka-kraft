#!/bin/bash

# Check if the .env file exists
if [ ! -f .env ]
then
  # Copy the .env.example file to .env
  cp .env.example .env
fi

# Load environment variables from .env file
export $(cat .env | sed 's/#.*//g' | xargs)

# Check if the KAFKA_KRAFT_CLUSTER_ID variable exists
if [ -z "$KAFKA_KRAFT_CLUSTER_ID" ]
then
  # Start a temporary Kafka container to generate a new cluster ID
  CLUSTER_ID=$(docker-compose run --rm kafka-1 kafka-storage.sh random-uuid)

  # Replace the cluster ID in the .env file
  sed -i "s/KAFKA_KRAFT_CLUSTER_ID=/KAFKA_KRAFT_CLUSTER_ID=$CLUSTER_ID/" .env

  # Export the cluster ID as an environment variable
  export KAFKA_KRAFT_CLUSTER_ID=$CLUSTER_ID
else
  echo "KAFKA_KRAFT_CLUSTER_ID already exists: $KAFKA_KRAFT_CLUSTER_ID"
fi

# Start the Kafka brokers
docker-compose up -d
