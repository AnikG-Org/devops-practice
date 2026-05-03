#!/bin/bash

# Export MinIO credentials for primary storage
export MINIO_ROOT_USER="admin-primary"
export MINIO_ROOT_PASSWORD="password-primary"

# Export MinIO credentials for backup storage
export MINIO_BACKUP_USER="admin-backup"
export MINIO_BACKUP_PASSWORD="password-backup"

