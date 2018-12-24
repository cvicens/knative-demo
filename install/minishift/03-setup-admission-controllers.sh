#!/bin/bash
# Enable admission controller webhooks
# The configuration stanzas below look weird and are just to workaround for:
# https://bugzilla.redhat.com/show_bug.cgi?id=1635918
minishift openshift config set --target=kube --patch '{
    "admissionConfig": {
        "pluginConfig": {
            "ValidatingAdmissionWebhook": {
                "configuration": {
                    "apiVersion": "v1",
                    "kind": "DefaultAdmissionConfig",
                    "disable": false
                }
            },
            "MutatingAdmissionWebhook": {
                "configuration": {
                    "apiVersion": "v1",
                    "kind": "DefaultAdmissionConfig",
                    "disable": false
                }
            }
        }
    }
}'

# wait until the kube-apiserver is restarted
until oc login -u admin -p admin; do sleep 5; done;