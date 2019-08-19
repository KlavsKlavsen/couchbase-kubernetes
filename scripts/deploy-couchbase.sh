#!/bin/bash
#
# Deploys/redeploys couchbase
# - Requires there to be a ETCD cluster running.
#
# params: $1 = namespace
#         $2 = pod name
#
# NB. $2 is ALSO used to calculate etcd cluster servicename !
#

set -ue

for f in couchbase-admin-server.yaml couchbase-server.yaml
do
  TMP=$(mktemp)
  cat ./replication-controllers/$f | sed -e "s:NAMESPACE:$1:" | sed -e "s:PODNAME:$2:" >$TMP
#  kubectl delete -n $1 -f $TMP
  kubectl apply -n $1 -f $TMP
done

#now add services
kubectl create -f services/couchbase-service.yaml -n $1
kubectl create -f services/couchbase-admin-service.yaml -n $1
