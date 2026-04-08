# dbt + DuckDB Data Platform

Apache Airflow with CeleryExecutor running dbt transformations on DuckDB with MinIO S3 storage.

## Architecture

| Service | Description |
|---------|-------------| 
| **airflow-api-server** | Web UI and REST API (port `8080`) |
| **airflow-scheduler** | Schedules DAG runs |
| **airflow-dag-processor** | Parses DAG files |
| **airflow-worker** | Celery worker that executes tasks |
| **airflow-triggerer** | Handles deferrable operators |
| **postgres** | Metadata database |
| **redis** | Celery message broker |
| **dbt** | Data transformation container with dbt-duckdb |
| **minio** | S3-compatible object storage |
| **duckdb** | SQL compute engine (embedded in dbt)  

## Prerequisites

- [Docker](https://docs.docker.com/get-docker/) ≥ 24.0
- [Docker Compose](https://docs.docker.com/compose/install/) ≥ 2.20
- At least **8 GB RAM** allocated to Docker

## Quick Start

```bash
# 1. Clone the repository and navigate to it
git clone <repo-url> && cd dbt-duckdb

# 2. Copy the example env file and edit as needed
cp .env.example .env

# 3. Generate required Airflow secret keys (for production, replace placeholders in .env)
python -c "from cryptography.fernet import Fernet; print(Fernet.generate_key().decode())"
# Copy the output and replace AIRFLOW__CORE__FERNET_KEY= value in .env

# 4. Start all services
make up

# 5. Check the logs to ensure everything started properly
make logs
```

> **Note:** On first run, services may take 1-2 minutes to initialize. Wait for all to show `healthy` status.

```bash
make status
```

## Common Operations

```bash
make up              # Start services in background
make down            # Stop all running services
make restart         # Restart all running services
make logs            # Follow all service logs
make reset           # Stop everything, remove volumes, and restart fresh
make status          # Show running containers
make shell           # Open a bash shell in the API server
```

## Project Structure

```
dbt-duckdb/
├── airflow/                     # Airflow service
│   ├── config/
│   │   └── airflow.cfg
│   ├── dags/
│   │   └── example_dbt_dag.py
│   ├── plugins/
│   └── logs/
├── dbt/                         # dbt project for transformations
│   ├── Dockerfile
│   ├── requirements.txt
│   ├── profiles.yml
│   └── dbt_project/
│       ├── dbt_project.yml
│       ├── models/
│       ├── tests/
│       ├── seeds/
│       └── macros/
├── minio/                       # MinIO service (S3-compatible storage)
│   └── entrypoint.sh
├── .env                         # Environment variables (git-ignored)
├── .env.example                 # Template for .env
├── docker-compose.yaml          # Service definitions
├── Makefile                     # Common operations
└── README.md
```

## Service URLs

| Service | URL | Default Credentials |
|---------|-----|-------------------|
| **Airflow UI** | http://localhost:8080 | `airflow` / `airflow` |
| **MinIO Console** | http://localhost:9001 | `minioadmin` / `minioadmin` |
| **PostgreSQL** | `localhost:5432` | user: `airflow` / `airflow` |

> **⚠️ Warning:** Change credentials in `.env` for any non-local environment.

## Configuration

- **Environment variables:** Edit `.env` (see `.env.example` for reference)
- **Airflow config:** Edit `config/airflow.cfg` — secrets are injected via env vars
- **dbt config:** Edit `dbt/profiles.yml` for DuckDB settings
- **Extra pip packages:** Set `_PIP_ADDITIONAL_REQUIREMENTS` in `.env`

> **⚠️ Security Note:** 
> - `.env.example` contains placeholder values for **local development only**
> - `.env` is excluded from git (see `.gitignore`) — never commit real credentials
> - For production: Generate unique FERNET_KEY, use strong passwords, store secrets in a vault (e.g., AWS Secrets Manager, HashiCorp Vault)

## Adding DAGs

Place Python files in the `dags/` directory. They will be automatically picked up by the DAG processor. The example DAG (`example_dbt_dag.py`) demonstrates how to orchestrate dbt commands (seed, run, test, docs) within Airflow tasks.