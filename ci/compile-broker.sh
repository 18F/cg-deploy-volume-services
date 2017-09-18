#!/bin/bash

set -eux

export GOPATH=$(pwd)/gopath
target="$(pwd)/compiled"

pushd gopath/src/code.cloudfoundry.org/nfsbroker
  go get ./...
  go build -o bin/nfsbroker
  cp -r bin "${target}/"
popd

cp config/ci/Procfile compiled
