#!/bin/bash

# Load the .env file and export the variables
set -a
source .env
set +a

# Check if the required environment variables are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_DEFAULT_REGION" ]; then
  echo "Required AWS environment variables are not set."
  exit 1
fi

# List all S3 buckets
aws s3 ls
