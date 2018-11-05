#!/usr/bin/env bash

if [ $# -ne 2 ]; then
  echo "Usage: setup-backend.sh [s3-bucket-name] [bucket-region]"
  exit 1
fi

TF_BACKEND_S3=$1
TF_BACKEND_S3_REGION=$2

# Create bucket
aws s3 mb s3://${TF_BACKEND_S3} \
  --region ${TF_BACKEND_S3_REGION}

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket ${TF_BACKEND_S3} \
  --versioning-configuration Status=Enabled
