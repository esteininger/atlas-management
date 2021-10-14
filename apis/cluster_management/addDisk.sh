#!/bin/bash
. ../../env.config


curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Content-Type: application/json" \
--include \
--request PATCH "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters?pretty=true" \
--data '{
  "diskSizeGB":1000
}'
