#!/bin/bash
#
# Deploys/redeploys couchbase
# - Requires there to be a ETCD cluster running.
#
# params: $1 = namespace
#         $2 = pod name
#         $3 = 'delete' - if set  removes it instead
#
# NB. $2 is ALSO used to calculate etcd cluster servicename !
#
if [ "$3" = "delete" ]
then
  ACTION="delete"
else
  ACTION="apply"
fi

set -ue

for f in couchbase-admin-server.yaml couchbase-server.yaml
do
  TMP=$(mktemp)
  cat ./replication-controllers/$f | sed -e "s:NAMESPACE:$1:" | sed -e "s:PODNAME:$2:" >$TMP
  kubectl $ACTION -n $1 -f $TMP
done

#now add services
kubectl $ACTION -f services/couchbase-service.yaml -n $1
kubectl $ACTION -f services/couchbase-admin-service.yaml -n $1
