"""
Example DAG: dbt Transformation Pipeline
Orchestrates dbt seed loading, model execution, and testing using the dbt container.
"""

from datetime import datetime, timedelta
from airflow import DAG
from airflow.operators.bash import BashOperator
from airflow.operators.docker_operator import DockerOperator
from airflow.utils.task_group import TaskGroup

# Default DAG arguments
default_args = {
    'owner': 'airflow',
    'depends_on_past': False,
    'start_date': datetime(2026, 1, 1),
    'retries': 1,
    'retry_delay': timedelta(minutes=5),
}

# DAG definition
dag = DAG(
    dag_id='example_dbt_transformation_pipeline',
    default_args=default_args,
    description='Orchestrates dbt seed loading, transformations, and testing',
    schedule_interval='@daily',
    catchup=False,
    tags=['dbt', 'transformation', 'iceberg'],
)

# Task: dbt seed (load raw data into DuckDB)
dbt_seed = BashOperator(
    task_id='dbt_seed',
    bash_command='docker exec dbt dbt seed --project-dir /dbt/dbt_project --profiles-dir /root/.dbt',
    dag=dag,
)

# Task: dbt run (execute all models)
dbt_run = BashOperator(
    task_id='dbt_run',
    bash_command='docker exec dbt dbt run --project-dir /dbt/dbt_project --profiles-dir /root/.dbt',
    dag=dag,
)

# Task: dbt test (validate data quality)
dbt_test = BashOperator(
    task_id='dbt_test',
    bash_command='docker exec dbt dbt test --project-dir /dbt/dbt_project --profiles-dir /root/.dbt',
    dag=dag,
)

# Task: dbt docs generate (generate documentation)
dbt_docs = BashOperator(
    task_id='dbt_docs_generate',
    bash_command='docker exec dbt dbt docs generate --project-dir /dbt/dbt_project --profiles-dir /root/.dbt',
    dag=dag,
)

# Task dependencies: seed -> run -> test -> docs
dbt_seed >> dbt_run >> dbt_test >> dbt_docs
