#!/bin/bash

manifests_yaml=release/kubernetes-manifests.yaml
redis_sharding=false
if [[ "$1" == "--redis-sharding" ]]; then
  redis_sharding=true
  manifests_yaml=release/kubernetes-redis-sharding-manifests.yaml
fi

echo "manifests_yaml: ${manifests_yaml}"
namespace="px-online-boutique"

kubectl create namespace "${namespace}"
kubectl apply --filename="${manifests_yaml}" --namespace="${namespace}"

# Uncomment the following are to use skaffold.
# repo="gcr.io/pl-dev-infra/demos/microservices-demo"
# skaffold run --default-repo="${repo}" --namespace="${namespace}"


if [[ "$redis_sharding" == true ]]; then
  echo "Wait for Redis shard pods to be ready ..."
  timeout=120s
  kubectl rollout status --watch --timeout="${timeout}" --namespace="${namespace}" statefulset/redis-cart
  if [[ $? != 0 ]]; then
    echo "Redis shards do not come ready after ${timeout}, exit ..."
    exit 1
  fi
  redis_cart_ips=$(kubectl get pods --namespace="${namespace}" -l app=redis-cart \
                   -o jsonpath='{range.items[*]}{.status.podIP}:6379 ')
  kubectl exec --namespace="${namespace}" -it redis-cart-0 -- redis-cli --cluster create \
    --cluster-replicas 1 ${redis_cart_ips} --cluster-yes
fi

kubectl port-forward svc/frontend 8080:80 --namespace="${namespace}"
