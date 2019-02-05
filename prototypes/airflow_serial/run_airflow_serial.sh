#!/bin/bash

export LC_ALL=en_US.UTF-8
export LANG=en_US.UTF-8
export AIRFLOW_HOME=`pwd`

airflow backfill ricopili_serial -s 2015-06-01 -e 2015-06-07
