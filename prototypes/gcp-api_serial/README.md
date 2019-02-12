# Ricopili --serial + Google Cloud Platform API

The same basic prototype: spin up an instance, copy some data over, run `preimp_dir --serial`, copying results down and shutting down the instance.  

Google provides a nice [python client](https://cloud.google.com/compute/docs/tutorials/python-guide) for interacting with GCE.  

The authorization story is a bit complicated. The standard would be what we have used for other prototypes: using the `gcloud` tool to create service accounts and then using the application default credentials to load the correct keys. This is typically used for things running in development, or on a GCE instance. This should be good enough for development.  

The correct way to do this would be something like creating a service account with [short lived credentials](https://cloud.google.com/iam/docs/creating-short-lived-service-account-credentials). I don't believe there is a python implementation for this (though check out this [doc](https://cloud.google.com/iam/docs/creating-managing-service-accounts). We would be sending requests and receiving responses against a server.  

Also, checkout: https://github.com/GoogleCloudPlatform/python-docs-samples/tree/master/compute/auth  

Useful resource about making requests and handling responses from the API:
https://cloud.google.com/compute/docs/api/how-tos/api-requests-responses


## Roadmap: 12.02.2019

A few problems we need to solve to get our minimum prototype running:

  1. add scp to instance
    - returning instance ip
    - connecting with proper credentials
  2. add docker to instance
    - running ricopili_docker
  3. add ssh to instance
    - running a remote command


