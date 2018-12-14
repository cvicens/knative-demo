
#!/bin/bash

sh 1-setup-minishift.sh
echo ">>>> 1 minishft console: http://`minishift ip`:8443 <<<<"

sh 2-login-minishift.sh
echo ">>>> 2 logged as: `oc whoami` <<<<"

echo ">>>> 3 setting up admission controllers <<<<"
sh 3-setup-admission-controllers.sh

echo ">>>> 4 deploying istio <<<<"
sh 4-deploy-istio-operator.sh

sleep 60

#echo ">>>> 5 deploying knative serving <<<<"
#sh 5-deploy-knative-serving.sh

#echo ">>>> 6 deploy go example and test it <<<<"
#sh 6-deploy-code.sh




