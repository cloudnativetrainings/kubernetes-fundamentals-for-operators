# Lost Pods

In this training, you will learn about Pods which will not get restarted.

> Navigate to the folder `04_no_restart` from CLI, before you get started.

## Setup Environment

```bash
# configure kubectl for being allowed to talk to the kubernetes cluster
export KUBECONFIG=/workspaces/kubernetes-fundamentals-for-operators/01_magicless-kubernetes/secrets/admin.kubeconfig
```

## Setup the workloads

### Inspect and create the Pod

Inspect pod.yaml definition file and create the pod

```bash
cat pod.yaml
kubectl create -f pod.yaml
```

### Inspect and create the Deployment

Inspect pod.yaml definition file and create the pod

```bash
cat deployment.yaml
kubectl create -f deployment.yaml
```

### Check the running Pods

```bash
kubectl get pods
```

## Maintenance Window ;)

### Drain all the Worker Nodes

```bash
# check the state of the nodes
kubectl get nodes

# try to drain the nodes, note that this will not work due to the manualy created pod
kubectl drain $PREFIX-worker-0 $PREFIX-worker-1 $PREFIX-worker-2

# force draining the noces
kubectl drain $PREFIX-worker-0 $PREFIX-worker-1 $PREFIX-worker-2 --force

# check the state of the nodes
kubectl get nodes

# check the pods
kubectl get pods
```

### Cordon all the Worker Nodes

```bash
# uncordon the worker nodes
kubectl uncordon $PREFIX-worker-0 $PREFIX-worker-1 $PREFIX-worker-2

# verify worker nodes state
kubectl get nodes
```

### Check the running Pods again

```bash
kubectl get pods
```

> Note that the manually created Pod was not restarted.

## Teardown

```bash
kubectl delete -f . --force --grace-period=0
```
