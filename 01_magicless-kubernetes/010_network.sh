#!/bin/bash

# TODO
# set -euxo pipefail

source ~/.trainingrc

# create the vpc
gcloud compute networks create $PREFIX-magicless-vpc --subnet-mode custom

# create the subnet
gcloud compute networks subnets create $PREFIX-magicless-subnet \
  --network $PREFIX-magicless-vpc \
  --range 10.254.254.0/24

# allow all internal traffic
gcloud compute firewall-rules create $PREFIX-magicless-internal \
  --action allow --rules all \
  --network $PREFIX-magicless-vpc \
  --source-ranges 10.254.254.0/24,192.168.0.0/16

# allow traffic from outside
gcloud compute firewall-rules create $PREFIX-magicless-inbound \
  --allow tcp:22,tcp:6443,icmp \
  --network $PREFIX-magicless-vpc \
  --source-ranges 0.0.0.0/0

# and let's have one static ip
gcloud compute addresses create $PREFIX-magicless-ip-address \
  --region $(gcloud config get-value compute/region)

# print out the static ip  
gcloud compute addresses list --filter="name=('$PREFIX-magicless-ip-address')"
