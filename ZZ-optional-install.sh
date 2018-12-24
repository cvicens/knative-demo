#!/bin/bash

export GOPATH=~/workspace/go
cd ~/workspace/go
mkdir bin pkg src
mkdir src/github.com

export PATH=$PATH:$GOPATH/bin

go get -u github.com/knative/build/cmd/logs