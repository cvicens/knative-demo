#!/bin/bash
. ./00-environment.sh

# Ref. https://maistra.io/docs/install/#_install_istio_into_existing_ocp_or_okd_environment

minishift ssh < prep-elasticsearch.sh

oc new-project istio-operator
oc new-app -f https://raw.githubusercontent.com/Maistra/openshift-ansible/${MAISTRA_ISTIO_VERSION}/istio/istio_community_operator_template.yaml --param=OPENSHIFT_ISTIO_MASTER_PUBLIC_URL="https://$(minishift ip):8443"

while oc get pods -n istio-operator | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done

cat << EOF | oc create -n istio-operator -f -
apiVersion: "istio.openshift.com/v1alpha1"
kind: "Installation"
metadata:
  name: "istio-installation"
spec:
  deployment_type: origin
  istio:
    authentication: false
    community: true
    prefix: maistra/
    version: 0.3.0
  jaeger:
    prefix: jaegertracing/
    version: 1.7.0
    elasticsearch_memory: 2Gi
  kiali:
    username: kialiadmin
    password: kialiadmin
    prefix: kiali/
    version: v0.8.1
EOF

while oc get pods -n istio-system | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done