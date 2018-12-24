#!/bin/bash

# Environment
. ./00-environment.sh

gcloud container clusters create ${CLUSTER_NAME} \
  --zone=${CLUSTER_ZONE} \
  --cluster-version=latest \
  --machine-type=${GKE_MACHINE_TYPE} \
  --enable-autoscaling --min-nodes=${GKE_MIN_NODES} --max-nodes=${GKE_MAX_NODES} \
  --enable-autorepair \
  --scopes=service-control,service-management,compute-rw,storage-ro,cloud-platform,logging-write,monitoring-write,pubsub,datastore \
  --num-nodes=${GKE_NUM_NODES}

kubectl create clusterrolebinding cluster-admin-binding \
--clusterrole=cluster-admin \
--user=$(gcloud config get-value core/account)

kubectl apply --filename https://github.com/knative/serving/releases/download/v0.2.2/istio.yaml

while kubectl get pods --namespace istio-system | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done

kubectl apply --filename https://github.com/knative/serving/releases/download/v0.2.2/release.yaml

while kubectl get pods --namespace knative-serving | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done
while kubectl get pods --namespace knative-build | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done

