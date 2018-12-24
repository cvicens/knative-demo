#!/bin/bash
. ./00-environment.sh

KNATIVE_SERVICE_NAME="greeter"
KNATIVE_SERVICE_VERSION="0.0.1"
DOMAIN_NAME="example.com"

#
# Edit the domain configuration config-map to replace example.com with your own domain, for example mydomain.com:
# 
# kubectl edit cm config-domain --namespace knative-serving
# This command opens your default text editor and allows you to edit the config map.
# 
# apiVersion: v1
# data:
#   example.com: ""
# kind: ConfigMap
# [...]
# Edit the file to replace example.com with the domain you'd like to use and save your changes. In this example, we configure mydomain.com for all routes:
# 
# apiVersion: v1
# data:
#   mydomain.com: ""
# kind: ConfigMap
# [...]

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
            image: ${PUBLIC_REGISTRY}/${PUBLIC_REGISTRY_USER}/${KNATIVE_SERVICE_NAME}:${KNATIVE_SERVICE_VERSION} # The URL to the image of the app
            env:
            - name: TARGET # The environment variable printed out by the sample app
              value: "Node Sample v1"
            resources:
              requests:
                memory: "64Mi"
                cpu: "250m"
              limits:
                memory: "128Mi"
                cpu: "600m"
EOF

kubectl get ksvc ${KNATIVE_SERVICE_NAME} --namespace ${PROJECT_NAME} -o yaml
kubectl get ksvc ${KNATIVE_SERVICE_NAME} --namespace ${PROJECT_NAME} --output=custom-columns=NAME:.metadata.name,DOMAIN:.status.domain

# Wait for the hello pod to enter its `Running` state
while kubectl get pods --namespace ${PROJECT_NAME} | grep -v -E "(Running|Completed|STATUS)"; do sleep 5; done

# Call the service 
export IP_ADDRESS=$(kubectl get svc knative-ingressgateway -n istio-system -o 'jsonpath={.status.loadBalancer.ingress[0].ip}')

# This should output 'NodeJs::Knative on OpenShift'
echo "================================================="
echo "curl -kv -H \"Host: ${KNATIVE_SERVICE_NAME}.${PROJECT_NAME}.${DOMAIN_NAME}\" http://$IP_ADDRESS"
echo "^"
echo "Run the above command to test the deployed service"