# GCP Ricopili serial + Airflow

The goal is to run `preimp_dir --cloud ...` implemented as an `airflow` DAG. We may consider developing as an airflow plugin, but we start with just a raw DAG.  

Workflow:  
  1. Clone down this repository.   
  2. Create conda environment using `requirements.txt`.  
  3. Initialize google cloud SDK via `init_gcloud.sh`.
  4. Initialize `airflow` db and start webserver via `start_airflow.sh`.  
  5. Run the `preimp_dir_serial` DAG via `run_airflow_serial.sh`.  

`preimp_dir_serial` DAG:
  1. Create GCP connection (authenticate user and project).
  2. Spin up worker VM.
  3. Upload PLINK files from local disk directly to the worker.
  4. Run `preimp_dir --serial ...` on the worker.
  5. Copy down output files (or upload to GCS bucket).
  6. Shutdown worker VM.

## GCP + airflow notes

 - [GCP connection for airflow](https://airflow.apache.org/howto/manage-connections.html#google-cloud-platform).  
 - [GCP authentication](https://google-auth.readthedocs.io/en/latest/reference/google.auth.html#google.auth.default). 
  
 - Is it better to use the `GCP` `Operators` or the `GCP` `Hook`? _it looks like the operators use the hook underneath the hood._  

 - What is a good set if `IAM` roles for the workflow runner?

## General notes
 
  - Separate out or check steps in the workflow that need initialization (e.g. service account creation).


