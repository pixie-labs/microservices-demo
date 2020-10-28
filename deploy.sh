# Used for deploy online boutique for Pixie demo

namespace="px-online-boutique"
repo="gcr.io/pl-dev-infra/demos/microservices-demo"

kubectl create namespace ${namespace}
skaffold run --default-repo=${repo} --namespace=${namespace} --tag=${USER}
kubectl port-forward svc/frontend 8080:80 -n ${namespace}
