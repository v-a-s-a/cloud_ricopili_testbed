#!/bin/bash

# initialize SDK on your computer
# TODO: what if it has already been initialized?
gcloud init

project_id="ripkelab2019"
service_account="ricopili-gcp-api"

# create service account
# TODO: what if service account already exists?
gcloud iam service-accounts create $service_account

# make credentials and store them in a safe location
gclouddir="${HOME}/.gcloud/keys/"
if [ ! -d "$gclouddir" ]; then
    mkdir $gclouddir
fi

ricopili_gcp_servicekey="${gclouddir}${service_account}.json"
gcloud iam service-accounts keys create --iam-account "${service_account}@${project_id}.iam.gserviceaccount.com" $ricopili_gcp_servicekey

# the airflow GCP hook picks up on this environment variable
export GOOGLE_APPLICATION_CREDENTIALS="$ricopili_gcp_servicekey"

# Grant the service account the correct roles
## TODO: what is the security risk here?
gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:${service_account}@${project_id}.iam.gserviceaccount.com --role roles/compute.admin

gcloud projects add-iam-policy-binding ${project_id} \
    --member serviceAccount:${service_account}@${project_id}.iam.gserviceaccount.com --role roles/iam.serviceAccountUser 

gcloud projects add-iam-policy-binding ${project_id} \
    --member user:vassily@broadinstitute.org --role roles/iam.serviceAccountUser
