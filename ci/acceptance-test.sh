#!/bin/bash

set -eux

cf api "${CF_API_URL}"
(set +x; cf auth "${CF_USERNAME}" "${CF_PASSWORD}")
cf t -o "${CF_ORGANIZATION}" -s "${CF_SPACE}"

pushd release-src/src/code.cloudfoundry.org/persi-acceptance-tests/assets/pora
  cf push --no-start pora
popd

cf create-service "${SERVICE_NAME:-nfs}" "${PLAN_NAME:-Existing}" "${INSTANCE_NAME:-nfs-volume}" -c <(cat <<EOF
{
  "uid": 1000,
  "gid": 1000,
  "share": "nfstestserver.service.cf.internal/export/${SHARE_ID}"
}
EOF
)
cf bind-service pora "${INSTANCE_NAME:-nfs-volume}"
cf start pora

url=$(cf app pora | grep routes | awk '{print $2}')
curl -f "https://${url}"
curl -f "https://${url}/write"

cf delete -f pora
cf delete-service -f "${INSTANCE_NAME:-nfs-volume}"
