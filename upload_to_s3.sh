#!/bin/bash

# Load the .env file and export the variables
set -a
source .env
set +a

# Function to display usage instructions
usage() {
  echo "Usage: $0 [-d target_directory] [-s storage_class] [-e] file_path"
  echo "  -d  Specify the target cloud directory"
  echo "  -s  Specify the storage class (e.g., STANDARD, REDUCED_REDUNDANCY, etc.)"
  echo "  -e  Enable encryption before upload"
  exit 1
}

# Validate and handle additional arguments
target_directory=""
storage_class=""
encryption=false

while getopts ":d:s:e" opt; do
  case ${opt} in
    d )
      target_directory=$OPTARG
      ;;
    s )
      storage_class=$OPTARG
      ;;
    e )
      encryption=true
      ;;
    \? )
      echo "Invalid option: $OPTARG" 1>&2
      usage
      ;;
    : )
      echo "Invalid option: $OPTARG requires an argument" 1>&2
      usage
      ;;
  esac
done
shift $((OPTIND -1))

# Check if file path is provided
if [ $# -lt 1 ]; then
  echo "File path is required."
  usage
fi

file_path=$1

# Check if the provided file path is valid and accessible
if [ ! -f "$file_path" ]; then
  echo "File does not exist or is not accessible: $file_path"
  exit 1
fi

# Set default storage class if not specified
if [ -z "$storage_class" ]; then
  storage_class="STANDARD"
fi

# Set up the destination path
file_name=$(basename "$file_path")
if [ -n "$target_directory" ]; then
  destination_path="s3://$S3_BUCKET_NAME/$target_directory/$file_name"
else
  destination_path="s3://$S3_BUCKET_NAME/$file_name"
fi

# Perform file encryption if enabled
if $encryption; then
  encrypted_file_path="${file_path}.enc"
  openssl enc -aes-256-cbc -salt -in "$file_path" -out "$encrypted_file_path" -k "your-encryption-password"
  file_path=$encrypted_file_path
fi

# Function to generate and display a shareable link
generate_shareable_link() {
  aws s3 presign "$destination_path" --expires-in 604800  # Link valid for 7 days
}

# Check if file already exists in the S3 bucket
if aws s3 ls "$destination_path" > /dev/null 2>&1; then
  echo "File already exists in the target location."
  select choice in "Overwrite" "Skip" "Rename"; do
    case $choice in
      Overwrite )
        break
        ;;
      Skip )
        echo "Upload skipped."
        [ "$encryption" = true ] && rm "$file_path"  # Clean up the encrypted file if created
        exit 0
        ;;
      Rename )
        read -p "Enter new name for the file: " new_file_name
        if [ -n "$target_directory" ]; then
          destination_path="s3://$S3_BUCKET_NAME/$target_directory/$new_file_name"
        else
          destination_path="s3://$S3_BUCKET_NAME/$new_file_name"
        fi
        break
        ;;
    esac
  done
fi

# Upload the file to the specified S3 bucket with progress bar
if command -v pv > /dev/null 2>&1; then
  pv "$file_path" | aws s3 cp - "$destination_path" --storage-class "$storage_class"
else
  aws s3 cp "$file_path" "$destination_path" --storage-class "$storage_class"
fi

# Check if the upload was successful
if [ $? -eq 0 ]; then
  echo "File uploaded successfully to $destination_path"
  generate_shareable_link 
  
else
  echo "Failed to upload the file."
  [ "$encryption" = true ] && rm "$file_path"  # Clean up the encrypted file if created
  exit 1
fi

# Clean up the encrypted file if created
[ "$encryption" = true ] && rm "$file_path"

