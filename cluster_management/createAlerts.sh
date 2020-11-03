#!/bin/bash
. ../env.config

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest \
     --request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/alertConfigs?pretty=true" \
     --header "Content-Type: application/json" \
     --data '{
    "enabled" : true,
    "eventTypeName" : "OUTSIDE_METRIC_THRESHOLD",
    "metricThreshold" : {
      "metricName" : "DOCUMENT_INSERTED",
      "mode" : "AVERAGE",
      "operator" : "GREATER_THAN",
      "threshold" : 40.0,
      "units" : "RAW"
    },
    "notifications" : [ {
      "delayMin" : 0,
      "emailEnabled" : true,
      "intervalMin" : 60,
      "smsEnabled" : false,
      "typeName" : "GROUP"
    } ],
    "typeName" : "HOST_METRIC",
    "updated" : "2019-07-09T13:29:13Z"
  }'