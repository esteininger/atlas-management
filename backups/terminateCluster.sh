#!/bin/bash
. ../env.config
CLUSTER=restore-target

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Content-Type: application/json" \
--include \
--request DELETE "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters/${CLUSTER}?pretty=true"