import os
import time
from datetime import timedelta

from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.utils.dates import days_ago

# set retry, in case file yet to reach destination folder
args = {
    'owner': 'airflow',
    'retries': 3,
    'retry_delay': timedelta(minutes=5)
}

with DAG(
    'Data_Pipeline',
    default_args=args,
    description='Section 1',
    schedule_interval="0 1 * * *",
    start_date=days_ago(1),
    tags=['GovTech', 'Section 1'],
) as dag:

    task1 = BashOperator(
        task_id='process_data',
        bash_command='python /opt/airflow/src/pipeline.py --input_folder /opt/airflow/src/raw'
    )

    task1