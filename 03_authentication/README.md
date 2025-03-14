# Authentication

In the training, we will learn about create authentication configuration using CSR, certificate and kubeconfig for a user to grant access over specific k8s cluster.

> Navigate to the folder `03_authentication` from CLI, before you get started.

## Setup Environment

```bash
# configure kubectl for being allowed to talk to the kubernetes cluster
export KUBECONFIG=/workspaces/kubernetes-fundamentals-for-operators/01_magicless-kubernetes/secrets/admin.kubeconfig
```

## Create the CSR

```bash
# create the key
openssl genrsa -out bob.key 2048

# create the CSR
openssl req -new -key bob.key -out bob.csr -subj "/CN=bob/O=eng"

# copy the content of the CSR into an environment variable
export CSR=$(cat bob.csr | base64 | tr -d '\n')

# use envsubst the set the CSR into the yaml file
envsubst < bob-csr-template.yaml > bob-csr.yaml

# apply the CSR
kubectl create -f bob-csr.yaml

# verify the "Pending" state of the CSR
kubectl get csr
```

## Approve the CSR

```bash
kubectl certificate approve bob
kubectl get csr
```

## Create a kubeconfig for Bob

```bash
# make a copy of the admins kube config file
cp $KUBECONFIG ./my-config.yaml

# store the certificate into the file bob.crt
kubectl get csr bob -o jsonpath='{.status.certificate}' | base64 --decode > bob.crt

# add the user Bob to my-config.yaml
kubectl config set-credentials bob \
  --client-certificate=bob.crt \
  --client-key bob.key \
  --embed-certs \
  --kubeconfig my-config.yaml

# create a context for Bob and the existing cluster
CURRENT_CLUSTER=$(kubectl config view -o jsonpath='{.clusters[].name}{"\n"}')
kubectl config set-context bob \
  --kubeconfig my-config.yaml \
  --cluster=$CURRENT_CLUSTER \
  --user=bob

# engage Bobs context
kubectl config use-context bob --kubeconfig my-config.yaml
```

## Verify your work

> Note that Bob has no permissions set up via RBAC yet.

```bash
# check if you can list pods via your admin user
kubectl get pods

# check if you cannot list pods via the user bob
kubectl --kubeconfig my-config.yaml get pods
```

## Verification via `can-i`

```bash
kubectl auth can-i get pods
kubectl auth can-i get pods --as bob
```

## Cleanup

```bash
kubectl delete csr bob
```
