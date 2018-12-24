#!/bin/bash
. ./00-environment.sh

oc new-project ${PROJECT_NAME}

# Set privileged scc to default SA in ${PROJECT_NAME}
oc adm policy add-scc-to-user privileged -z default -n ${PROJECT_NAME}

# Automatic Istio sidecar injection
oc label namespace ${PROJECT_NAME} istio-injection=enabled
oc get namespace --show-labels | grep ${PROJECT_NAME}