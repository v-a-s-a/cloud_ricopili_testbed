#!/bin/bash

GOOGLE_APPLICATION_CREDENTIALS='/Users/vasa/.gcloud/keys/ricopili-gcloud.json'

# instance creation
gcloud compute instances create-with-container test-ricopili-docker-03 \
    --container-image=eu.gcr.io/ripkelab2019/ricopili_docker:latest \
    --container-mount-host-path=host-path=/tmp,mount-path=/scratch \
    --container-restart-policy=never

# file upload
gcloud compute scp test.txt ricopili-gcloud@test-ricopili-docker-03:/tmp/

# TODO: ssh run container
gcloud compute ssh ricopili-gcloud@test-ricopili-docker-03 \
    --command="docker run eu.gcr.io/ripkelab2019/ricopili_docker preimp_dir --help"

# TODO: copy down results

# TODO: add instance deletion
