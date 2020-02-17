#!/bin/bash
. ../env.config

CLUSTER=sample

curl --user "${PUBLICKEY}:${PRIVATEKEY}" \
  --digest --include \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters/${CLUSTER}/backup/snapshots?pretty=true" \
  --data '{
      "description": "SomeDescription",
      "retentionInDays": 5
    }'