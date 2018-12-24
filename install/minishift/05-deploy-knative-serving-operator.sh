#!/bin/bash
. ./00-environment.sh

# Configure necessary privileges to the service accounts used by knative
curl -s https://raw.githubusercontent.com/knative/docs/master/install/scripts/knative-openshift-policies.sh | bash

# Deploy Knative serving
curl -L https://storage.googleapis.com/knative-releases/serving/latest/release-no-mon.yaml \
  | sed 's/docker.io\/istio\/.*$/maistra\/proxyv2-centos7:0.3.0/' \
  | sed 's/istio-pilot:8080/istio-pilot.istio-system:15005/' \
  | oc apply -f -

# Monitor...
while oc get pods -n knative-build | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done
while oc get pods -n knative-serving | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done

if [ ${OS} = 'osx' ]
then
sudo route -n add -net $(minishift openshift config view | grep ingressIPNetworkCIDR | awk '{print $NF}') $(minishift ip)
else
sudo ip route add $(minishift openshift config view | grep ingressIPNetworkCIDR | sed 's/\r$//' | awk '{print $NF}') via $(minishift ip)
fi