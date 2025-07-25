#!/bin/bash

source /root/.trainingrc
source ./000_func.sh

public=$(public_ip)

# create the master nodes
for i in 0 1 2; do
  # only the first master node gets a static ip
  [ $i = 0 ] && addr_arg="--address $public" || addr_arg=""
  gcloud compute instances create $PREFIX-master-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image=ubuntu-2204-jammy-v20240319 \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-2 \
    --private-network-ip 10.254.254.10$i \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet $PREFIX-magicless-subnet \
    --tags magicless,$PREFIX-master $addr_arg
done

# create the worker nodes
for i in 0 1 2; do
  gcloud compute instances create $PREFIX-worker-${i} \
    --async \
    --boot-disk-size 200GB \
    --can-ip-forward \
    --image=ubuntu-2204-jammy-v20240319 \
    --image-project ubuntu-os-cloud \
    --machine-type n1-standard-1 \
    --metadata pod-cidr=192.168.1${i}.0/24 \
    --private-network-ip 10.254.254.20${i} \
    --scopes compute-rw,storage-ro,service-management,service-control,logging-write,monitoring \
    --subnet $PREFIX-magicless-subnet \
    --tags magicless,$PREFIX-worker
done

gcloud compute instances list
