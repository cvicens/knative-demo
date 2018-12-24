#!/bin/bash
. ./00-environment.sh

LOCAL_IMAGE_NAME=dev.local/greeter:0.0.2
REMOTE_IMAGE_NAME=${PUBLIC_REGISTRY}/${PUBLIC_REGISTRY_USER}/greeter:0.0.2

echo "Run if GKE: gcloud auth configure-docker"

cd java/

echo "Maven package ..."

./mvnw -DskipTests clean package
#./mvnw spring-boot:run 

echo "Local docker build..."
./mvnw -DskipTests clean package jib:dockerBuild -Dimage=${LOCAL_IMAGE_NAME}
./mvnw -DskipTests clean package jib:build -Dimage=${REMOTE_IMAGE_NAME}

#docker tag ${LOCAL_IMAGE_NAME} ${REMOTE_IMAGE_NAME}
#docker push ${REMOTE_IMAGE_NAME}