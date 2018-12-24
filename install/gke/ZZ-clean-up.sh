#!/bin/bash

# Environment
. ./00-environment.sh


gcloud container clusters delete $CLUSTER_NAME --zone $CLUSTER_ZONE

read -p "Delete project ${GCP_PROJECT_ID}? (y/N) " DELETE_PROJECT
echo ${DELETE_PROJECT}
DELETE_PROJECT=$(echo ${DELETE_PROJECT} | tr '[:lower:]' '[:upper:]')

if [ "${DELETE_PROJECT}" = "Y" ] ; then
    gcloud projects delete ${GCP_PROJECT_ID}
fi




