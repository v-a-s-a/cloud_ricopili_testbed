import os

from airflow import DAG
from airflow.operators.bash_operator import BashOperator
from airflow.contrib.operators.gcp_compute_operator import GceInstanceStartOperator, GceInstanceStopOperator
from datetime import datetime, timedelta


default_args = {
    'owner': 'vasa',
    'depends_on_past': False,
    'start_date': datetime(2015, 6, 1),
    'email_on_failure': False,
    'email_on_retry': False,
    'retries': 1,
    'retry_delay': timedelta(seconds=60)
}

dag = DAG('ricopili_serial',
    default_args=default_args,
    schedule_interval=None)


# Cloud credentials: should be set in environment via `cloud sdk`
GCP_PROJECT_ID = os.environ.get('GCP_PROJECT_ID', 'ripkelab2019')
GCE_ZONE = os.environ.get('GCE_ZONE', 'us-east1-b')
GCE_INSTANCE = os.environ.get('GCE_INSTANCE', 'airflow-serial-test')


## TASKS

start_vm = GceInstanceStartOperator(
    project_id=GCP_PROJECT_ID,
    zone=GCE_ZONE,
    resource_id=GCE_INSTANCE,
    task_id='start_vm',
    dag=dag)

hang_out = BashOperator(
    task_id='hang_out',
    bash_command='sleep 60',
    retries=3,
    dag=dag)

stop_vm = GceInstanceStopOperator(
    project_id=GCP_PROJECT_ID,
    zone=GCE_ZONE,
    resource_id=GCE_INSTANCE,
    task_id='stop_vm',
    dag=dag)


## DAG spec.

start_vm >> hang_out >> stop_vm
