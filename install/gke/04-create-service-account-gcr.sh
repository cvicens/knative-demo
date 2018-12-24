#!/bin/bash
. ./00-environment.sh

# Create a Service Account
gcloud iam service-accounts \
    create knative-build \
    --display-name "Knative Build"

# Allow it to push to GCR
gcloud projects \
    add-iam-policy-binding ${GCP_PROJECT_ID} \
    --member \
    serviceAccount:knative-build@${GCP_PROJECT_ID}.iam.gserviceaccount.com \
    --role roles/storage.admin

# Create a JSON key
gcloud iam service-accounts keys \
    create knative-key.json \
    --iam-account \
    knative-build@${GCP_PROJECT_ID}.iam.gserviceaccount.com

# create a Kubernetes secret from the JSON key:
kubectl create secret generic \
    knative-build-auth \
    --type="kubernetes.io/basic-auth" \
    --from-literal=username="_json_key" \
    --from-file=password=knative-key.json \
    --namespace ${PROJECT_NAME}

# To tell the Build to use those parameters when pushing to gcr.io, we need to add an annotation to the secret. 
# That's called Guided credential selection. https://github.com/knative/docs/blob/master/build/auth.md#guiding-credential-selection
kubectl annotate secret \
    knative-build-auth \
    build.knative.dev/docker-0=https://gcr.io \
    --namespace ${PROJECT_NAME}

# Create a Service Account in kubernetes
cat << EOF | kubectl apply --namespace ${PROJECT_NAME} -f -
apiVersion: v1
kind: ServiceAccount
metadata:
  name: knative-build
secrets:
- name: knative-build-auth
EOF

