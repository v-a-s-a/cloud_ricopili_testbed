# GCP Ricopili serial + Airflow

The goal is to run `preimp_dir --cloud ...` implemented as an `airflow` DAG. We may consider developing as an airflow plugin, but we start with just a raw DAG.  

Workflow:  
  1. Create conda environment using `environment.txt`.  
  2. Clone down this repository.  
  3. Start `airflow` db and webserver.  
  4. Run the `preimp_dir_serial` DAG.  

`preimp_dir_serial` DAG:
  1. Create GCP connection (authenticate user and project).
  2. Spin up worker VM.
  3. Upload file from local directly to the worker.
  4. Run `preimp_dir --serial ...` on the worker.
  5. Copy down output files (or upload to GCS bucket).
  6. Shutdown worker VM.

## environment

`conda install -c conda-forge airflow` 




