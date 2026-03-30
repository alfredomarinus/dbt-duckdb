FROM python:3.11-slim

# Set working directory
WORKDIR /dbt

# Install system dependencies
RUN apt-get update && apt-get install -y \
    git \
    curl \
    && rm -rf /var/lib/apt/lists/*

# Copy requirements
COPY requirements.txt .

# Install Python dependencies
RUN pip install --no-cache-dir -r requirements.txt

# Set dbt home
ENV DBT_PROFILES_DIR=/root/.dbt

# Default command
CMD ["dbt", "--version"]
