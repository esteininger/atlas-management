#!/bin/bash
. ../env.config

CLUSTER='sample'
DAYS_OF_USER_LIFE=1

DELETE_AFTER_DATE=$(date -v +${DAYS_OF_USER_LIFE}d "+%Y-%m-%dT%H:%M:%SZ")

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--include \
--request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/databaseUsers?pretty=true" \
--data-raw '
  {
    "databaseName": "admin",
    "deleteAfterDate": "'${DELETE_AFTER_DATE}'",
    "username": "foo1",
    "password": "bar",
    "roles": [
        {
            "databaseName": "admin",
            "roleName": "atlasAdmin"
        }
    ]
  }
'
