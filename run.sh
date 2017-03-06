#!/usr/bin/env bash

set -e

echo '** Make sure that Docker is running, or else the build will fail!'
sleep 2
echo '...'
sleep 1
echo 'Starting build...'
sleep 1

# Build the project and docker images
#mvn clean install -DskipTests=true

# Export the active docker machine IP
#export DOCKER_IP=$(docker-machine ip $(docker-machine active))

# docker-machine doesn't exist in Linux, assign default ip if it's not set
export DOCKER_IP=0.0.0.0

# Remove existing containers
docker-compose stop
docker-compose rm -f

docker-compose up -d neo4j-db

# Start the Neo4j data base
while [ -z ${NEO4J_READY} ]; do
  echo "Waiting for up Neo4j ..."
  if [ "$(curl --silent http://$DOCKER_IP:7474/db/data/ 2>&1 | grep -q "neo4j_version"; echo $?)" = 0 ]; then
      NEO4J_READY=true;
  fi
  sleep 2
done
echo "Neo4j is ready ..."

# Start the config service first and wait for it to become available
docker-compose up -d configserver

while [ -z ${CONFIG_SERVICE_READY} ]; do
  echo "Waiting for config service..."
  if [ "$(curl --silent $DOCKER_IP:8888/health 2>&1 | grep -q '\"status\":\"UP\"'; echo $?)" = 0 ]; then
      CONFIG_SERVICE_READY=true;
  fi
  sleep 2
done

# Start the discovery service next and wait
docker-compose up -d discovery

while [ -z ${DISCOVERY_SERVICE_READY} ]; do
  echo "Waiting for discovery service..."
  if [ "$(curl --silent $DOCKER_IP:8761/health 2>&1 | grep -q '\"status\":\"UP\"'; echo $?)" = 0 ]; then
      DISCOVERY_SERVICE_READY=true;
  fi
  sleep 2
done

# Start the other containers
docker-compose up

# Attach to the log output of the cluster
#docker-compose logs
