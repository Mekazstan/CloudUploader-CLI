#!/bin/bash

# Load the .env file and export the variables
set -a
source .env
set +a

# Check if the required environment variables are set
if [ -z "$AWS_ACCESS_KEY_ID" ] || [ -z "$AWS_SECRET_ACCESS_KEY" ] || [ -z "$AWS_DEFAULT_REGION" ] || [ -z "$S3_BUCKET_NAME" ]; then
  echo "Required AWS environment variables are not set."
  exit 1
fi

# Check if the AWS CLI is installed
if ! command -v aws &> /dev/null; then
  echo "AWS CLI is not installed. Please install it to use this script."
  exit 1
fi

# Prompt the user for the file to upload
read -p "Enter the path to the file you want to upload: " file_path

# Debugging
# echo $file_path

# Check if the file exists
if [ ! -f "$file_path" ]; then
  echo "File does not exist: $file_path"
  exit 1
fi

# Store the destination path in a variable
destination_path="s3://$S3_BUCKET_NAME/$(basename "$file_path")"

# Debugging
# echo $destination_path

# Upload the file to the specified S3 bucket
aws s3 cp "$file_path" "$destination_path"

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo "File uploaded successfully to $destination_path"
else
  echo "Failed to upload the file."
fi