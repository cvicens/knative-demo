#!/bin/bash
. ./00-environment.sh

kubectl apply --namespace ${PROJECT_NAME} -f ./build-templates/java-buildah.yaml

cat << EOF | kubectl apply --namespace ${PROJECT_NAME} -f -
kind: PersistentVolumeClaim
apiVersion: v1
metadata:
  name: m2-cache
spec:
  accessModes:
    - ReadWriteOnce
  resources:
    requests:
      storage: 8Gi
EOF
