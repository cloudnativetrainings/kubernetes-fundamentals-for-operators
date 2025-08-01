#!/bin/bash

source /root/.trainingrc

for x in {0..2}; do
  gcloud compute routes create $PREFIX-k8s-pod-route-192-168-1${x}-0-24 \
    --network $PREFIX-magicless-vpc \
    --next-hop-address 10.254.254.20${x} \
    --destination-range 192.168.1${x}.0/24
done

gcloud compute routes list --filter "network: $PREFIX-magicless-vpc"
