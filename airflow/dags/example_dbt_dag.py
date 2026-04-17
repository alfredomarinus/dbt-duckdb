from datetime import datetime, timedelta
from airflow.sdk import dag, task

@dag(
    dag_id='example_dbt_transformation_pipeline',
    description='Orchestrates dbt seed loading, transformations and testing',
    start_date=datetime(2026, 1, 1),
    schedule=None,
    catchup=False,
    tags=['dbt', 'transformation', 'duckdb'],
)
def example_dbt_transformation_pipeline():
    """
    dbt Transformation Pipeline DAG
    
    Tasks:
    - dbt seed: Load raw data into DuckDB
    - dbt run: Execute all models
    - dbt test: Validate data quality
    - dbt docs generate: Generate documentation
    
    Dependencies: seed -> run -> test -> docs
    """
    
    @task.bash(task_id='dbt_seed')
    def dbt_seed():
        """Load raw data into DuckDB"""
        return 'docker exec dbt dbt seed --target prod'
    
    @task.bash(task_id='dbt_run')
    def dbt_run():
        """Execute all dbt models"""
        return 'docker exec dbt dbt run --target prod'
    
    @task.bash(task_id='dbt_test')
    def dbt_test():
        """Validate data quality with dbt tests"""
        return 'docker exec dbt dbt test --target prod'
    
    @task.bash(task_id='dbt_docs_generate')
    def dbt_docs():
        """Generate dbt documentation"""
        return 'docker exec dbt dbt docs generate'
    
    # Set task dependencies: seed -> run -> test -> docs
    dbt_seed() >> dbt_run() >> dbt_test() >> dbt_docs()

example_dbt_transformation_pipeline()