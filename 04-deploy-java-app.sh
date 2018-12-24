#!/bin/bash
. ./00-environment.sh

KNATIVE_SERVICE_NAME="greeter"
KNATIVE_SERVICE_VERSION="0.0.2"
DOMAIN_NAME="example.com"

echo "Configurations:"
kubectl get configurations.serving.knative.dev --namespace ${PROJECT_NAME}
echo "Revisions:"
kubectl get revisions.serving.knative.dev --namespace ${PROJECT_NAME}

cat << EOF | kubectl apply --namespace ${PROJECT_NAME} -f -
apiVersion: serving.knative.dev/v1alpha1
kind: Service
metadata:
  name: ${KNATIVE_SERVICE_NAME}
spec:
  runLatest:
    configuration:
      revisionTemplate:
        spec:
          container:
            image: ${PUBLIC_REGISTRY}/${PUBLIC_REGISTRY_USER}/${KNATIVE_SERVICE_NAME}:${KNATIVE_SERVICE_VERSION}
            env:
             - name: MESSAGE_PREFIX 
               value: "Hola "
            resources:
              requests:
                memory: "64Mi"
                cpu: "250m"
              limits:
                memory: "128Mi"
                cpu: "600m"
EOF

kubectl get ksvc ${KNATIVE_SERVICE_NAME} --namespace ${PROJECT_NAME} -o yaml
kubectl get ksvc ${KNATIVE_SERVICE_NAME} --namespace ${PROJECT_NAME} --output=custom-columns=NAME:.metadata.name,§MAIN:.status.domain

# Wait for the hello pod to enter its `Running` state
while kubectl get pods --namespace ${PROJECT_NAME} | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done

# Call the service 
export IP_ADDRESS=$(kubectl get svc knative-ingressgateway -n istio-system -o 'jsonpath={.status.loadBalancer.ingress[0].ip}')

# This should output 'NodeJs::Knative on OpenShift'
echo "================================================="
echo "curl -kv -H \"Host: ${KNATIVE_SERVICE_NAME}.${PROJECT_NAME}.${DOMAIN_NAME}\" http://$IP_ADDRESS"
echo "^"
echo "Run the above command to test the deployed service"