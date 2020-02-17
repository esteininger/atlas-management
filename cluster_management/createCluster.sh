#!/bin/bash
. ../env.config

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Content-Type: application/json" \
--include \
--request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters?pretty=true" \
--data '
     {
  "autoScaling": {
    "diskGBEnabled": true
  },
  "backupEnabled": false,
  "name": "sample",
  "providerSettings": {
    "providerName": "AWS",
    "instanceSizeName": "M10",
    "regionName":"US_EAST_1"
  }
}'
