#!/bin/bash
. ../../env.config

CLUSTER='ClusterName'

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--include \
--request PATCH "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters/${CLUSTER}?pretty=true" \
--data '
  {"labels": [{"key":"mDeleter", "value":"{2022-01-01}"}]}
'
