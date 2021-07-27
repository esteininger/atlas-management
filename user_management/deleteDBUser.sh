#!/bin/bash
. ../env.config

CLUSTER='sample'
DATABASENAME='admin'
DATABASEUSER='test_user'

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--include \
--request DELETE "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/databaseUsers/${DATABASENAME}/${DATABASEUSER}"
