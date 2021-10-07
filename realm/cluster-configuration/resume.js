exports = async function() {
  // get keys
  const public_key = context.values.get("public_key");
  const private_key = context.values.get("private_key");
  const group_id = context.values.get("group_id");
  const cluster_list = context.values.get("cluster_list")

  // body
  const body = {
    "paused": "false"
  }

  // iterate over cluster list
  for (let cluster in cluster_list) {

    // args
    const arg = {
      scheme: 'https',
      host: 'cloud.mongodb.com',
      path: `api/atlas/v1.0/groups/${group_id}/clusters/${cluster}?pretty=true`,
      username: public_key,
      password: private_key,
      headers: {
        'Content-Type': ['application/json'],
        'Accept-Encoding': ['bzip, deflate']
      },
      digestAuth: true,
      body: JSON.stringify(body)
    };

    // send the patch
    response = await context.http.patch(arg);

    // TODO: also notify app server of cluster resuming from pause

    // print readable msg
    console.log(JSON.stringify(response));
  }
}
