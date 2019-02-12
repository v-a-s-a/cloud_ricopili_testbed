#!/bin/bash
project_id="ripkelab2019"
service_account="ricopili-gcp-api"
gclouddir="${HOME}/.gcloud/keys/"
ricopili_gcp_servicekey="${gclouddir}${service_account}.json"
export GOOGLE_APPLICATION_CREDENTIALS="$ricopili_gcp_servicekey"