#!/bin/bash
. ../../env.config


CLUSTER='sample'

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--include \
--request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/databaseUsers?pretty=true" \
--data-raw '
  {
    "databaseName": "admin",
    "username": "foo",
    "password": "bar",
    "roles": [
        {
            "databaseName": "admin",
            "roleName": "atlasAdmin"
        }
    ]
  }
'
