#!/bin/bash

set -euxo pipefail

# source ~/.trainingrc

# and let's have one static ip
gcloud compute addresses create magicless-ip-address

# print out the static ip  
gcloud compute addresses list --filter="name=('magicless-ip-address')"
