#!/bin/bash

export PROJECT_NAME="serverless"

export OS="osx" # osx | linux

export MINISHIFT_VERSION="v3.11.0"

export MINISHIFT_PROFILE="knative"
export MINISHIFT_MEMORY="8GB"
export MINISHIFT_CPUS="4"
export MINISHIFT_VM_DRIVER="xhyve" # xhyve | virtualbox | kvm
export MINISHIFT_DISK_SIZE="50g"

export MAISTRA_ISTIO_VERSION="maistra-0.5"

#### GCP
export CLUSTER_NAME=knative
export CLUSTER_ZONE=europe-west1-b

export GCP_PROJECT_ID=knative-project

export GKE_MACHINE_TYPE=f1-micro