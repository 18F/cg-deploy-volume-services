#!/bin/bash

set -eux

export GOPATH=$(pwd)/release-src
export PATH=$PATH:$GOPATH/bin
target=$(pwd)/compiled

go get github.com/onsi/ginkgo/ginkgo
go get github.com/onsi/gomega

pushd release-src/src/code.cloudfoundry.org/nfsbroker
  ginkgo -r
  go build -o bin/nfsbroker
  cp -r bin "${target}/"
popd

cp config/ci/Procfile compiled
