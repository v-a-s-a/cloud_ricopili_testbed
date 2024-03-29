# Cloud Ricopili: Prototypes

## Aims
### 1: command-line-based, serial-mode prototype

Implementing `preimp_dir --cloud ...` that can launch from a local or cluster-login terminal.  

Options:
  1. Using Apache Airflow to handle authentication, provisioning, launching and shutdown.
  2. Coding directly against the GCP API (with any bindings, e.g. python or bash)


### 2: scalable backend

Implementing a `preimp_dir --cloud ...` that utilizes more than one VM to complete tasks.

Options:
  1. Worflow management with `airflow` wrapping `slurm-gcp` or `elasticluster`.
  2. Worflow management coded directly against the GCP API, with `slurm-gcp` or `elasticluster`.
  3. Using [`dsub`](https://cloud.google.com/genomics/docs/tutorials/dsub) as a "custom" cluster backend for ricopili.


### Target environments

True portability may be a dream:

  1. Broad UGER
  2. LISA
  3. BIH cluster
  4. Local machines: macos, windows.

We definitely need to be able to run this from LISA.

## Cloud Tools

There are various frameworks and tools that we can use to make our lives (hopefully) easier.

### Apache Airflow

[Airflow](https://airflow.apache.org)  

This looks like it can handle:  
  - [linking a google account](https://airflow.apache.org/howto/manage-connections.html#connection-type-gcp) to a specific run
  - [spinning up and shutting down VMs](https://airflow.apache.org/integration.html#compute-engine)
  - [file transfer](https://airflow.apache.org/integration.html#cloud-storage)

### GCP API

They have CLI clients, e.g. [`gcloud compute`](https://cloud.google.com/compute/docs/gcloud-compute/).  

They also have a [python library](https://cloud.google.com/compute/docs/tutorials/python-guide).

In my experience, something like `OAuth` is actually non-trivial to code by hand. It would be nice if someone else did this for us.

### `slurm-gcp`

[Slurm on Google Cloud Platform](https://github.com/SchedMD/slurm-gcp)  

Interesting project that spins up a SLURM cluster that support pre-emptible instances and re-scaling running clusters.

[`slurm-gcp` tutorial](https://codelabs.developers.google.com/codelabs/hpc-slurm-on-gcp/#0).  

### `elasticluster`  

[ElastiCluster](https://github.com/gc3-uzh-ch/elasticluster). 

Similar to the `gcp-slurm` project above, except much more flexible. They support other cloud providers, other schedulers, and other storage backends (e.g. a gluster NFS).  

### `gcsfuse`

[User-space file system backed by Gooogle Cloud Storage](https://github.com/GoogleCloudPlatform/gcsfuse). 

Mount a Google Cloud Bucket as a FUSE filesystem.


## Packaging

How can we package this tool for distribution?  

__Docker-ize Ricopili__: this allows us to run ricopili jobs within a standard container. External data resources may be an issue.  
__GCP VMs__: Work with VM snapshots that have ricopili installed into them. Sharing VMs between projects may be an issue. A true "system" install of ricopili may be difficult.  
__Installation recipe__: Have a `gcp.custom.txt` install file for a standard cloud VM. Install from `tar.gz` in a "headless" mode.  
