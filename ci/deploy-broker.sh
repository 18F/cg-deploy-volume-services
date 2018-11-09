#!/bin/bash

set -eux

cat > vars.yml <<- "EOF"
development-auth-name: ${USERNAME}
development-auth-pass: ${PASSWORD}
EOF
spruce merge vars.yml "${MANIFEST}" > manifest.yml

cf api "${CF_API_URL}"
(set +x; cf auth "${CF_USERNAME}" "${CF_PASSWORD}")
cf target -o "${CF_ORGANIZATION}" -s "${CF_SPACE}"

cf zero-downtime-push "${APP-NAME}" -p compiled -m manifest.yml
