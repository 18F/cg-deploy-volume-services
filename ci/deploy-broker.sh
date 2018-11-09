#!/bin/bash

set -eux
go get github.com/geofffranks/spruce/...
curl -L "https://cli.run.pivotal.io/stable?release=linux64-binary&source=github" | tar xzv -C /usr/local/bin cf && \
cf install-plugin autopilot -f -r CF-Community

cat > vars.yml <<EOF
env:
  USERNAME: ${USERNAME}
  PASSWORD: ${PASSWORD}
EOF
spruce merge "${MANIFEST}" vars.yml > manifest.yml

cf api "${CF_API_URL}"
(set +x; cf auth "${CF_USERNAME}" "${CF_PASSWORD}")
cf target -o "${CF_ORGANIZATION}" -s "${CF_SPACE}"

cf zero-downtime-push "${APP_NAME}" -p compiled -f manifest.yml
