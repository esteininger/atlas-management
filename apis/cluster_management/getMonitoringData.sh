#!/bin/bash
. ../env.config

HOST=""
PORT=27017
curl -u "${PUBLICKEY}:${PRIVATEKEY}" --digest -i\
 "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/processes/${HOST}:${PORT}/measurements?granularity=PT1M&period=PT10M&pretty=true"