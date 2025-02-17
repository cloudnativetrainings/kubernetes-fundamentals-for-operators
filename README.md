# Kubernetes Fundamentals for Operators

## Setup training environment

```bash
# activate your gcloud service account
# copy your file `gcloud-service-account.json` into your github codespaces workspace
gcloud auth activate-service-account --key-file=./gcloud-service-account.json
gcloud config set project <PROJECT_ID>
gcloud config set compute/region europe-west3
gcloud config set compute/zone europe-west3-a
# TODO can I set this on creating the projects via terraform?

# TODO force bash only in codespaces

# TODO ssh-private-key
ssh-keygen -q

# adapt bash environment
echo "export PREFIX=<TRAINEE_NAME>" >> .trainingrc
mv .trainingrc ~
source ~/.trainingrc
echo "source ~/.trainingrc" >> ~/.bashrc

# verify training environment
make verify
```

## Teardown training environment

```bash
make teardown
```
