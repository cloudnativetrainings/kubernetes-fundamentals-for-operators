#!/bin/bash

source /root/.trainingrc

# copy secrets
for node in worker-{0..2}; do
  gcloud compute scp secrets/$PREFIX-${node}.pem \
                     secrets/$PREFIX-${node}-key.pem \
                     secrets/$PREFIX-${node}.kubeconfig \
                     secrets/kube-proxy.kubeconfig \
                     secrets/ca.pem \
                     $PREFIX-${node}:
done                     

# copy config files
for node in worker-{0..2}; do
  gcloud compute scp configs/10-bridge.conf \
                     configs/99-loopback.conf \
                     configs/containerd-config.toml \
                     configs/crictl.yaml \
                     configs/kube-proxy-config.yaml \
                     configs/kubelet-config.yaml \
                     services/containerd.service \
                     services/kube-proxy.service \
                     services/kubelet.service \
                     $PREFIX-${node}:
done

# copy shell scripts
for node in worker-{0..2}; do
  gcloud compute scp 2*.sh $PREFIX-${node}:
done

# copy .trainingrc file
for node in worker-{0..2}; do
    gcloud compute scp /root/.trainingrc $PREFIX-${node}:/root/.trainingrc
done
