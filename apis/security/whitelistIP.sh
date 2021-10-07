#!/bin/bash
. ../../env.config


curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--include \
--request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/accessList?pretty=true" \
--data-raw '
  [
    {
      "ipAddress" : "0.0.0.0",
      "comment" : "Allow all IP addresses for server"
    }
  ]
'
