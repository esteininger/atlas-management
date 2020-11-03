Atlas API Workshop
===

## Lab 1: Generating Your API Key
Atlas API keys can be created at either the organization or project level. For the purposes of this tutorial, we'll just need a project level API key. Here are the steps to get started:

Create an API Key for a Project
1. From the Context menu, select the project that you want to view.
2. Under the Project section on the left navigation panel, click Access Management.
3. Click the tab for API Keys.
4. Select Create API Key from the Manage button menu.
5. From the API Key Information step of the Add API Key page, enter a description for the new API Key in the Description box.
6. Select the new role or roles for the API Key from the Project Permissions menu.
7. Copy and save the Public Key.
8. The public key acts as the username when making API requests.
9. Click Next.
10. From the Private Key & Whitelist step of the Add API Key page, click Add Whitelist Entry.
11. Enter an IPv4 address from which you want Atlas to accept API requests for this API Key.
12. You can also click Use Current IP Address if the host you are using to access Atlas also will make API requests using this API Key.
13. Click Save.

## Lab 2: Using the API to Create a Cluster
Start by taking a look at the ```createCluster.sh``` script. Essentially what's happening here is that we're sending a post request to the Atlas API targeting the project we want to use (the group id). We can break down the url in this case into two components. The Atlas root: ```https://cloud.mongodb.com/api/atlas/v1.0``` and the resource we want to modify ```/groups/${GROUPID}/clusters```. By sending a post to this resource, we can tell Atlas to spin up a new cluster.

The body of the request (the value for the ```--data``` flag in curl) defines the settings for the cluster we want to create. In this case we're creating a cluster in AWS. The cluster will be an M10 and located in the US East 1 region.

Follow these steps to create your cluster:

1. Add your group id (same as project id!), private key, and public key to the ```env.config``` file. This file is referenced in all of the sample scripts so we don't have to keep setting these variables over and over for the rest of the workshop.
2. Make sure all the scripts in the ```cluster_management``` directory can be executed ```chmod +x cluster_management/*```
3. Run the script to create a cluster. 

```bash
cd cluster_management
./createCluster.sh
```

4. You should get a response with the configuration of the cluster being created.
5. Let's check the status of our cluster to see if it is done starting up. Examine the ```getClusters.sh``` script. This is very similar to creating a cluster, but we're sending a GET instead of a POST. Run ```./getClusters.sh```
6. Take a look at the stateName field in the response. If it says CREATING, we'll need to wait a bit longer. If it says IDLE, your cluster is ready to go and you're done with the lab!


## Lab 3: Scaling
Now that we have our cluster up and running, we may need to scale up our cluster to handle an anticipated increase in workload. Imagine we're running an app within the education industry, and we need to scale up our clusters to handle increased traffic at the beginning of the school year.

1. Examine ```scaleUp.sh```. This will look similar to the script we used to create the cluster, however we're sending a PATCH instead of a POST. We're also specifying the cluster name in the url. The body of the PATCH will be the cluster settings we want to change. In this case, we're changing the providerSettings attribute.

```javascript
    {
    "providerSettings": {
        "providerName": "AWS", // providerName is always required
        "instanceSizeName": "M30" // our new instance size
        }
    }
```

2. Run ```./scaleUp.sh```
3. Did it work? Let's find out by running ```./getClusters.sh```. When we look at the response the stateName field should be UPDATING. Check again after about 10 minutes, that value should have changed back to IDLE, which indicates our cluster has successfully scaled from an M10 to an M30.

Keep in mind, clusters remain available while scaling, so you can change your cluster size without downtime!

Let's now imagine that our education app has been working great all year. It is now June and most schools are now on summer break. We can now scale our cluster back down to an M10.

1. Examine the ```scaleDown.sh``` script. This will look exactly like ```scaleUp.sh``` except instanceSizeName is now set to M10 in the body of the request.
2. Run ```./scaleDown.sh```
3. Run ```./getClusters.sh``` and verify that the stateName is now UPDATING. Run ```./getClusters.sh``` again after about 10 minutes to verify the cluster is back to IDLE.

Scaling up and down so we only use the compute power we need is a great way to keep costs down in Atlas. For our non-production environments, we can take our cluster management even further to make sure we don't pay for compute power we aren't using. In Atlas, we have the ability to [pause](https://docs.atlas.mongodb.com/pause-terminate-cluster/#pause-a-cluster) a cluster. While a cluster is paused, we can no longer connect to the cluster, however all the data stays in place. We also only need to pay for storage, not compute, so we'll get a substantial cost savings. If we know for example that a cluster won't be used over the weekend, we should pause it every Friday afternoon and resume it Monday morning.

To pause your cluster...
1. Examine ```pauseCluster.sh```. All the script really does is update our cluster configuration and set the "paused" attribute to true.
2. Run ```./pauseCluster.sh```
3. Run ```./getClusters.sh``` and verify that the value of the cluster's "paused" attribute is true.
4. Finally, resume the cluster by running ```./resumeCluster.sh```. This sets the ```paused``` value for the cluster to ```false```.

## Lab 4: Managing Backups
Atlas makes it easy for us to create and manage database backups. In some cases, we may want to automate the backup / restore process. One example where this automation would be helpful is the creation of a temporary cluster for QA testing. We could send Atlas an API call to create a new cluster that matches production, then another API call to restore a backup into this new cluster. We could then run all of our QA tests against this new cluster. Finally, when the testing is complete, we can terminate the new cluster so we don't spend Atlas credits unnecessarily.

Let's now use the API to enable backup, create a backup snapshot, and restore that snapshot to a new cluster.

1. First, we'll need a cluster to restore our backup into. Create a copy of the ```createCluster.sh``` script. Name the copy ```createAnotherCluster.sh```.
2. Edit ```createAnotherCluster.sh``` and change the "name" field in the post body (the --data flag) to ```restore-target```.
3. While our new cluster is being created, navigate to the ```backups``` directory and examine ```enableBackup.sh```. This sends another PATCH to modify our cluster settings and set providerBackupEnabled to true. This will enable the use of cloud provider snapshots for backup.

Atlas will eventually take a backup of our cluster automatically. But we don't have time to wait. Let's load some data into our cluster, and then tell Atlas to take a backup right now.

4. Load sample data into your Atlas cluster named "sample" using the GUI. See instructions [here](https://docs.atlas.mongodb.com/sample-data/).
5. Examine ```takeSnapshot.sh```. Have a look at the POST url and notice the target CLUSTER/backup/snapshots. For the body, we just need to define a description of the snapshot and the number of days that the snapshot should be retained.
6. Run ```./takeSnapshot.sh``` to trigger the snapshot. Wait a couple minutes for the snapshot to complete. You can check on the progress of your snapshot by running the ```getBackups.sh``` script. This will send a GET to CLUSTER/backup/snapshots and retrieve a list of snapshots for a cluster.

Finally, we can restore the backup to our "restore-target" cluster.

7. Run ```./getBackups.sh``` and take note of the value for the ```id``` field. We'll need this later.
8. Examine ```restoreBackup.sh```. In order to restore a backup, we need to send a POST to CLUSTER/backup/restoreJobs to create a new restore job. In the POST body, we need to specify the ID fo the snapshot we are restoring from, the name of our target cluster, and the group id (project id) for the project that contains the target cluster.
```json
    {
      "snapshotId" : "$SNAPSHOTID",
      "deliveryType" : "automated",
      "targetClusterName" : "${TARGET}",
      "targetGroupId" : "${GROUPID}"
    }
```
9. Modify the SNAPSHOTID variable in ```restoreBackup.sh``` to match the ID of the snapshot you want to restore from (see step 7 to get this ID).
10. Run ```./restoreBackup.sh``` and wait a few minutes for the restore to complete. Then, in the Atlas GUI navigate to the collections tab for the "restore-target" cluster and verify the data has been restored.

## Lab 5: Terminating a Cluster
Now that we've restored a backup to our QA cluster (restore-target), and we have presumably completed all of our QA tests, we can now go ahead and terminate that cluster.

1. Examine ```terminateCluster.sh```. Here we send a DELETE request to a specific cluster (in this case "restore-target). This will terminate the cluster.
2. Run ```./terminateCluster.sh```.

## Lab 6: Create and View Alerts
Atlas provides users with the ability to configure custom alerts based on different events (such as an election within a replica set) or metric thresholds. In this lab, we'll create an alert that will notify us if the number of documents being inserted each second exceeds 40.
1. Examine ```createAlerts.sh```. We're sending a POST to the "alertConfigs" endpoint. In the ```--data``` field, we're specifying that we want to have an alert triggered if a metric threshold is reached. In this case, that metric is ```DOCUMENT_INSERTED``` and the threshold is 40.
2. Run ./createAlerts.sh
3. Run ./getAlerts.sh (a GET requests to the alertConfigs endpoint) and ensure that your new alert is included in the result set.


## Lab 7: Challenge - Creating Automated QA Clusters
Your capstone project is to build a working system to automate the workflow described in Lab 4. Using your favorite programming language, create an application that will use the Atlas api to...
1. Create a QA cluster
2. Restore a backup of production (use the "sample" cluster created earlier as the production cluster).
3. Run this query on the sample_mflix database in the QA cluster
```javascript
    db.movies.find({"cast":"Tom Hanks"});
```
4. Terminate the cluster.

This program should require no human intervention once started, so it will need to be able to check the status of the cluster so that the next step can be run at the appropriate time.
