#!/bin/bash
. ../../env.config


CLUSTER='sample'

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--include \
--request GET "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/databaseUsers?pretty=true"
