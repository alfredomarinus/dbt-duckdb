FROM python:3.11-slim

# Set working directory
WORKDIR /dbt

# Install system dependencies (including build tools)
RUN apt-get update && apt-get install -y \
    git \
    curl \
    build-essential \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir --upgrade pip setuptools wheel && \
    pip install --no-cache-dir -r requirements.txt && \
    pip install --no-cache-dir duckdb-cli

# Set dbt home
ENV DBT_PROFILES_DIR=/root/.dbt

# Default command
CMD ["dbt", "--version"]