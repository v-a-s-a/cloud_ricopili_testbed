#!/bin/bash

GOOGLE_APPLICATION_CREDENTIALS='/Users/vasa/.gcloud/keys/ricopili-gcloud.json'

# instance creation
gcloud compute instances create-with-container ricopili-docker \
    --container-image=eu.gcr.io/ripkelab2019/ricopili_docker:latest \
    --container-mount-host-path=host-path=/tmp,mount-path=/scratch \
    --container-restart-policy=never
    --container-command="bash -c"

# wait for things to sync
sleep 5

# file upload
gcloud compute scp ../../test/data/test_sample_02.* ricopili-gcloud@ricopili-docker:/tmp/

# create a volume to store data
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker volume create data"

# get a container running in the background
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker create --interactive --tty --name ricopili --mount type=volume,source=data,target=/scratch eu.gcr.io/ripkelab2019/ricopili_docker"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker start ricopili"

# copy files into newly created volume
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="sudo chmod o+r /tmp/*"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp /tmp/test_sample_02.fam ricopili:/scratch/"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp /tmp/test_sample_02.bed ricopili:/scratch/"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp /tmp/test_sample_02.bim ricopili:/scratch/"

# initial run of preimp_dir
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker exec  ricopili /bin/sh -c 'cd /scratch ; preimp_dir --dis scz --pop eur --outname test --maf 0.01 --serial'"

# TODO: edit scz.names and run again
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker exec  ricopili4 /bin/sh -c 'cd /scratch ; preimp_dir --dis scz --pop eur --outname test --maf 0.01 --serial'"


# copy down results
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp ricopili:/scratch/qc/scz_scz1_eur_RP-qc.bed /tmp/"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp ricopili:/scratch/qc/scz_scz1_eur_RP-qc.bim /tmp/"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp ricopili:/scratch/qc/scz_scz1_eur_RP-qc.fam /tmp/"

gcloud compute scp ricopili-gcloud@ricopili-docker:/tmp/*-qc* ~/

# delete instance
gcloud compute instances delete ricopili-docker 
