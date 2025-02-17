#!/bin/bash

# TODO
#  set -euxo pipefail

source ~/.trainingrc

# copy secrets
for node in master-{0..2}; do
  gcloud compute scp secrets/ca{,-key}.pem \
                     secrets/kubernetes{,-key}.pem \
                     secrets/service-account{,-key}.pem \
                     secrets/encryption-config.yaml \
                     secrets/{admin,kube-controller-manager,kube-scheduler}.kubeconfig \
                     $PREFIX-${node}:
done

# copy config files
for node in master-{0..2}; do
  gcloud compute scp services/{etcd,kube-apiserver,kube-controller-manager,kube-scheduler}.service $PREFIX-${node}:
  gcloud compute scp configs/kube-scheduler.yaml configs/kube-apiserver-to-kubelet.yaml $PREFIX-${node}:
done

# copy shell scripts
for node in master-{0..2}; do
  gcloud compute scp 1*.sh $PREFIX-${node}:
done

# copy .trainingrc file
for node in master-{0..2}; do
  gcloud compute scp ~/.trainingrc $PREFIX-${node}:~/.trainingrc
done
