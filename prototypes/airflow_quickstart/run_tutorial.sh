#!/bin/bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export AIRFLOW_HOME=`pwd`

airflow test tutorial print_date 2015-06-01

airflow test tutorial sleep 2015-06-01

airflow test tutorial templated 2015-06-01

