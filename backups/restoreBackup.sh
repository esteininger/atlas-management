#!/bin/bash
. ../env.config

CLUSTER=sample
TARGET=restore-target

#use the getBackups.sh script to get snapshot id
SNAPSHOTID=YourSnapshotIdHere

curl --user "${PUBLICKEY}:${PRIVATEKEY}" --digest --include \
  --header "Accept: application/json" \
  --header "Content-Type: application/json" \
  --request POST "https://cloud.mongodb.com/api/atlas/v1.0/groups/${GROUPID}/clusters/${CLUSTER}/backup/restoreJobs" \
  --data "
    {
      \"snapshotId\" : \"$SNAPSHOTID\",
      \"deliveryType\" : \"automated\",
      \"targetClusterName\" : \"${TARGET}\",
      \"targetGroupId\" : \"${GROUPID}\"
    }
  "