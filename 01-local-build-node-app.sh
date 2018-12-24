#!/bin/bash
. ./00-environment.sh

echo "Remember to run this if you want to use GCP registry: gcloud auth configure-docker"

cd node/
npm install

LOCAL_IMAGE_NAME=dev.local/greeter:0.0.1
REMOTE_IMAGE_NAME=${PUBLIC_REGISTRY}/${PUBLIC_REGISTRY_USER}/greeter:0.0.1

docker build --rm -t ${LOCAL_IMAGE_NAME} .
echo ">>>> Image built: $(docker images | grep dev.local)"

docker tag ${LOCAL_IMAGE_NAME} ${REMOTE_IMAGE_NAME}
docker push ${REMOTE_IMAGE_NAME}