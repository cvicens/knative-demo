#!/bin/bash
. ./00-environment.sh

#oc new-project ${PROJECT_NAME}
kubectl create namespace ${PROJECT_NAME}

# Automatic Istio sidecar injection
kubectl label namespace ${PROJECT_NAME} istio-injection=enabled
kubectl get namespace --show-labels | grep ${PROJECT_NAME}