#!/bin/bash
. ./00-environment.sh

BUILD_NAME="jib-build-hello"

# Delete 1st just in case we want to retry
kubectl delete build ${BUILD_NAME} --namespace ${PROJECT_NAME}

cat << EOF | kubectl apply --namespace ${PROJECT_NAME} -f -
apiVersion: build.knative.dev/v1alpha1
kind: Build
metadata:
  name: ${BUILD_NAME}
spec:
  serviceAccountName: knative-build
  source:
    git:
      url: https://github.com/dgageot/hello-jib.git
      revision: master
  steps:
  - name: build-and-push
    image: gcr.io/cloud-builders/mvn
    args: ["compile", "jib:build", "-Dimage=gcr.io/${GCP_PROJECT_ID}/hello-jib"]
    volumeMounts:
    - name: mvn-cache
      mountPath: /root/.m2

  volumes:
  - name: mvn-cache
    persistentVolumeClaim:
      claimName: cache
---
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: cache
spec:
  accessModes:
    - ReadWriteOnce
  volumeMode: Filesystem
  resources:
    requests:
      storage: 8Gi
EOF

# Let's see the logs...
kubectl logs -f $(kubectl get build ${BUILD_NAME} -ojsonpath={.status.cluster.podName} --namespace ${PROJECT_NAME}) \
   -c build-step-unnamed-0 --namespace ${PROJECT_NAME}

