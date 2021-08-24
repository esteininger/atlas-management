#!/bin/bash
. ../env.config
CLUSTER='sample'

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
--header "Accept: application/json" \
--header "Content-Type: application/json" \
--include \
--request PATCH "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters/${CLUSTER}?pretty=true" \
--data '{
  "replicationSpecs" : [ {
    "id" : "Replica_Set_ID",
    "numShards" : 1,
    "regionsConfig" : {
      "US_EAST_1" : {
        "analyticsNodes" : 0,
        "electableNodes" : 1,
        "priority" : 6,
        "readOnlyNodes" : 0
      },
      "US_EAST_2" : {
        "analyticsNodes" : 0,
        "electableNodes" : 2,
        "priority" : 7,
        "readOnlyNodes" : 0
      }
    },
    "zoneName" : "Zone 1"
  } ]
}'
