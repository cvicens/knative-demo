#!/bin/bash
. ./00-environment.sh

KNATIVE_SERVICE_NAME="greeter"
KNATIVE_SERVICE_VERSION="0.0.3"
DOMAIN_NAME="example.com"

REGISTRY="gcr.io/knative-project-cva"

#kubectl delete build ${KNATIVE_SERVICE_NAME}-00001 --namespace ${PROJECT_NAME}

cat << EOF | kubectl apply --namespace ${PROJECT_NAME} -f -
apiVersion: serving.knative.dev/v1alpha1
kind: Service
metadata:
  name: ${KNATIVE_SERVICE_NAME}
spec:
  runLatest:
    configuration:
      build:
        serviceAccountName: builder
        source:
          git:
            url: https://github.com/workspace7/knative-build-blogs
            revision: master
        template:
          name: java-buildah
          arguments:
            - name: IMAGE_NAME
              value: "${REGISTRY}/${KNATIVE_SERVICE_NAME}:${KNATIVE_SERVICE_VERSION}"
            - name: CONTEXT_DIR
              value: "part-1/java"
            - name: JAVA_APP_NAME
              value: "greeter.jar"
            - name: CACHE
              value: m2-cache
        volumes:
          - name: m2-cache
            persistentVolumeClaim:
              claimName: m2-cache
      revisionTemplate:
        metadata:
          labels:
            app: ${KNATIVE_SERVICE_NAME}
          annotations:
            alpha.image.policy.openshift.io/resolve-names: "*"
        spec:
          container:
            # This should be a fully qualified domain name e.g. quay.io/example/myimage:mytag
            # This is configured to use the inbuilt default docker registry
            image: ${REGISTRY}/${KNATIVE_SERVICE_NAME}:${KNATIVE_SERVICE_VERSION}
EOF
