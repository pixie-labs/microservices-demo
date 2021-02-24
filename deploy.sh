namespace="px-online-boutique2"

kubectl create namespace ${namespace}
kubectl apply --filename=release/kubernetes-manifests.yaml --namespace=${namespace}
# Uncomment the following are to use skaffold.
# repo="gcr.io/pl-dev-infra/demos/microservices-demo"
# skaffold run --default-repo=${repo} --namespace=${namespace}

kubectl port-forward svc/frontend 8080:80 --namespace=${namespace}
