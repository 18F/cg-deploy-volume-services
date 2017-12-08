#!/bin/bash

set -eux

export GOPATH=$(pwd)/gopath
export PATH=$PATH:$GOPATH/bin
target="$(pwd)/compiled"

go get github.com/golang/dep/cmd/dep
go get github.com/onsi/ginkgo/ginkgo
go get github.com/onsi/gomega

pushd gopath/src/code.cloudfoundry.org/nfsbroker
  dep init
  ginkgo -r
  go build -o bin/nfsbroker
  cp -r bin "${target}/"
popd

cp config/ci/Procfile compiled
