#!/usr/bin/env bash

if [ -z $1 ]; then
  echo "Usage: setup-backend.sh [s3_bucket]"
  exit 1
fi

TF_BACKEND_S3=$1

# Create bucket
aws s3 mb s3://${TF_BACKEND_S3} \
  --region ${AWS_REGION}

# Enable versioning
aws s3api put-bucket-versioning \
  --bucket ${TF_BACKEND_S3} \
  --versioning-configuration Status=Enabled
