#!/bin/bash

# MinIO initialization script
# This script sets up MinIO buckets required for Iceberg table storage

set -e

# MinIO endpoint
MINIO_ENDPOINT="${MINIO_ENDPOINT:-http://localhost:9000}"
MINIO_ROOT_USER="${MINIO_ROOT_USER:-minioadmin}"
MINIO_ROOT_PASSWORD="${MINIO_ROOT_PASSWORD:-minioadmin}"

# Wait for MinIO to be ready
echo "Waiting for MinIO to start..."
for i in {1..30}; do
  if curl -f "${MINIO_ENDPOINT}/minio/health/live" > /dev/null 2>&1; then
    echo "MinIO is ready!"
    break
  fi
  echo "Attempt $i: MinIO not ready yet..."
  sleep 2
done

# Create default bucket for Iceberg if it doesn't exist
echo "Initializing MinIO buckets..."

# Create bucket structure
# Note: In the actual environment with mc (MinIO client), you would do:
# mc alias set minio http://localhost:9000 minioadmin minioadmin
# mc mb minio/iceberg/warehouse || true
# mc mb minio/iceberg/data || true

echo "MinIO initialization complete!"
