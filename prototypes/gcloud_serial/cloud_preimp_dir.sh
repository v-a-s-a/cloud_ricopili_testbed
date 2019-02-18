#!/bin/bash

GOOGLE_APPLICATION_CREDENTIALS='/Users/vasa/.gcloud/keys/ricopili-gcloud.json'


echo "Starting VM..."
gcloud compute instances create-with-container ricopili-docker \
    --container-image=eu.gcr.io/ripkelab2019/ricopili_docker:latest \
    --container-mount-host-path=host-path=/tmp,mount-path=/scratch \
    --container-restart-policy=never 
sleep 5 # wait for things to sync

echo "Uploading data to host VM..."
gcloud compute scp ../../test/data/test_sample_02.* ricopili-gcloud@ricopili-docker:/tmp/


echo "Creating a data volume..."
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker volume create data"


echo "Creating container..."
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker create --interactive --tty --name ricopili --mount type=volume,source=data,target=/scratch eu.gcr.io/ripkelab2019/ricopili_docker"

echo "Creating container..."
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker start ricopili"

echo "Copy data from host VM into volume..."
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="sudo chmod o+r /tmp/*"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp /tmp/test_sample_02.fam ricopili:/scratch/"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp /tmp/test_sample_02.bed ricopili:/scratch/"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp /tmp/test_sample_02.bim ricopili:/scratch/"

echo "Running preimp_dir..."
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker exec  ricopili /bin/sh -c 'cd /scratch ; preimp_dir --dis scz --pop eur --outname test --maf 0.01 --serial'"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker exec  ricopili /bin/sh -c 'cd /scratch ; preimp_dir --dis scz --pop eur --outname test --maf 0.01 --serial'"


echo "Moving data out of volume and onto the host VM..."
gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp ricopili:/scratch/qc/scz_scz1_eur_RP-qc.bed /tmp/"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp ricopili:/scratch/qc/scz_scz1_eur_RP-qc.bim /tmp/"

gcloud compute ssh ricopili-gcloud@ricopili-docker \
    --command="docker cp ricopili:/scratch/qc/scz_scz1_eur_RP-qc.fam /tmp/"

echo "Moving data from host VM to local machine..."
gcloud compute scp ricopili-gcloud@ricopili-docker:/tmp/*-qc* ~/

echo "Deleting VM..."
gcloud compute instances delete --quiet ricopili-docker 
