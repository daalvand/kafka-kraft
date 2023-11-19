#!/bin/bash

# Check if the .env file exists
if [ ! -f .env ]
then
  # Copy the .env.example file to .env
  cp .env.example .env
fi

# Load environment variables from .env file
export $(cat .env | sed 's/#.*//g' | xargs)

# Check if the CLUSTER_ID variable exists
if [ -z "$CLUSTER_ID" ]
then
  # Start a temporary Kafka container to generate a new cluster ID
  CLUSTER_ID=$(docker compose -f docker-compose.single.yml run --rm kafka kafka-storage random-uuid)


  # Replace the cluster ID in the .env file
  sed -i "s/CLUSTER_ID=/CLUSTER_ID=$CLUSTER_ID/" .env

  # Export the cluster ID as an environment variable
  export CLUSTER_ID=$CLUSTER_ID
else
  echo "CLUSTER_ID already exists: $CLUSTER_ID"
fi

# Start the Kafka brokers
docker compose -f docker-compose.single.yml up -d
