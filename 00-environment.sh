#!/bin/bash

export PROJECT_NAME="serverless"

export OS="osx" # osx | linux

export MINISHIFT_VERSION="v3.11.0"

export MINISHIFT_PROFILE="knative"
export MINISHIFT_MEMORY="8GB"
export MINISHIFT_CPUS="4"
export MINISHIFT_VM_DRIVER="xhyve" # xhyve | virtualbox | kvm
export MINISHIFT_DISK_SIZE="50g"