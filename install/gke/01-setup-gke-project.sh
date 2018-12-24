#!/bin/bash

# Environment
. ./00-environment.sh

# Log in GCP
gcloud auth login

read -p "Create project ${GCP_PROJECT_ID}? (y/N) " CREATE_PROJECT
echo ${CREATE_PROJECT}
CREATE_PROJECT=$(echo ${CREATE_PROJECT} | tr '[:lower:]' '[:upper:]')

if [ "${CREATE_PROJECT}" = "Y" ] ; then
  echo "Creating project ${GCP_PROJECT_ID} and setting it as default"
  gcloud projects create ${GCP_PROJECT_ID} --set-as-default
else
  echo "Setting project ${GCP_PROJECT_ID} as default"
  gcloud config set core/project ${GCP_PROJECT_ID}
fi

echo "Enabling needed apis"
gcloud services enable \
  cloudapis.googleapis.com \
  container.googleapis.com \
  containerregistry.googleapis.com

echo "Before proceeding with the next step, be sure you have enabled billing for your project"
open "https://console.cloud.google.com/billing/linkedaccount?project=${GCP_PROJECT_ID}"