#!/bin/bash

export AIRFLOW_HOME=`pwd`

airflow initdb
airflow webserver -p 8080
airflow scheduler

