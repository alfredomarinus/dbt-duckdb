#!/bin/bash
set -e

# Load environment variables from .env
export $(grep -v '^#' .env | xargs)

echo "Starting export to MinIO..."

docker compose exec -T dbt duckdb /dbt/duckdb/analytics_dev.duckdb << SQL
LOAD httpfs;

SET s3_endpoint='minio:9000';
SET s3_access_key_id = '${MINIO_ACCESS_KEY}';
SET s3_secret_access_key = '${MINIO_SECRET_KEY}';
SET s3_url_style='path';
SET s3_use_ssl=false;

COPY main.dim_customers_agg TO 's3://dbt-data/dim_customers_agg.parquet' (FORMAT PARQUET);
COPY main.fct_sales TO 's3://dbt-data/fct_sales.parquet' (FORMAT PARQUET);

SELECT 'Export completed successfully!' as status;
SQL

echo "✓ Export completed!"