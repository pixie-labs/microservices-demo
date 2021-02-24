# Pixie fork of online-boutique

This is a pixie fork of the official *online-boutique* repo. We maintain this for producing custom
demo scenarios for showcasing Pixie.

## Using `skaffold`

If you need to modify `online-boutique` for certain demo scenarios, you can deploy to your
K8s cluster with `skaffold`. Skaffold will build the iamges, upload them to `gcr.io`,
and then deploy them onto your cluster.

```shell
git clone https://github.com/GoogleCloudPlatform/microservices-demo.git
cd microservices-demo
kubectl create namespace px-online-boutique
skaffold run --namespace=px-online-boutique \
  --default-repo=gcr.io/pl-dev-infra/demos/microservices-demo-app
```
