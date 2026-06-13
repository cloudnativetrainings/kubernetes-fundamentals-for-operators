#!/bin/false

# this is meant to be run on each master node

source /root/.trainingrc

# create folders
sudo mkdir -p /var/lib/kubernetes/

# download binaries
wget -q --show-progress --https-only --timestamping \
  "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kube-apiserver" \
  "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kube-controller-manager" \
  "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kube-scheduler" \
  "https://dl.k8s.io/release/v$KUBERNETES_VERSION/bin/linux/amd64/kubectl"

# install binaries
sudo install -o root -m 0755 kube{ctl,-apiserver,-controller-manager,-scheduler} /usr/local/bin/

# copy config and cert files
sudo install -o root -m 0644 ca.pem kubernetes.pem service-account.pem encryption-config.yaml /var/lib/kubernetes/
sudo install -o root -m 0600 ca-key.pem kubernetes-key.pem service-account-key.pem /var/lib/kubernetes/
sudo install -o root -m 0600 kube{-controller-manager,-scheduler}.kubeconfig /var/lib/kubernetes/
