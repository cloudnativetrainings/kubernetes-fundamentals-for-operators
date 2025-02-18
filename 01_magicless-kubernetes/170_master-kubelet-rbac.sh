#!/bin/bash

source ~/.trainingrc

kubectl apply --kubeconfig secrets/admin.kubeconfig -f configs/kube-apiserver-to-kubelet.yaml
