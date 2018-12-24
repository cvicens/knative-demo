#!/bin/bash
. ./00-environment.sh

BUILD_NAME="hello"

# Delete 1st just in case we want to retry
kubectl delete build ${BUILD_NAME} --namespace ${PROJECT_NAME}

cat << EOF | kubectl apply --namespace ${PROJECT_NAME} -f -
apiVersion: build.knative.dev/v1alpha1
kind: Build
metadata:
  name: ${BUILD_NAME}
spec:
  steps:
  - image: busybox
    args: ['echo', 'Hello, World!']
EOF

# Let's see the logs...
kubectl logs -f $(kubectl get build ${BUILD_NAME} -ojsonpath={.status.cluster.podName} --namespace ${PROJECT_NAME}) \
   -c build-step-unnamed-0 --namespace ${PROJECT_NAME}