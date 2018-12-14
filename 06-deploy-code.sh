#!/bin/bash
. ./0-environment.sh

oc new-project ${PROJECT_NAME}

# Set privileged scc to default SA in ${PROJECT_NAME}
oc adm policy add-scc-to-user privileged -z default -n ${PROJECT_NAME}
# Automatic Istio sidecar injection
oc label namespace ${PROJECT_NAME} istio-injection=enabled
oc get namespace --show-labels -n ${PROJECT_NAME}

echo '
apiVersion: serving.knative.dev/v1alpha1 # Current version of Knative
kind: Service
metadata:
  name: helloworld-go # The name of the app
spec:
  runLatest:
    configuration:
      revisionTemplate:
        spec:
          container:
            image: gcr.io/knative-samples/helloworld-go # The URL to the image of the app
            env:
            - name: TARGET # The environment variable printed out by the sample app
              value: "Go Sample v1"
' | oc create -n ${PROJECT_NAME} -f -

# Wait for the hello pod to enter its `Running` state
#while oc get pods -n ${PROJECT_NAME} | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done

# Call the service 
#export IP_ADDRESS=$(oc get svc knative-ingressgateway -n istio-system -o 'jsonpath={.status.loadBalancer.ingress[0].ip}')

# This should output 'Hello World: Go Sample v1!'
#curl -kv -H "Host: helloworld-go.serverless.example.com" http://$IP_ADDRESS