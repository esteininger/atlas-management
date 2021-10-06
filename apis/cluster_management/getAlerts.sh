#!/bin/bash
. ../env.config

curl -X GET -u "${PUBLICKEY}:${PRIVATEKEY}" --digest "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/alertConfigs?pretty=true"