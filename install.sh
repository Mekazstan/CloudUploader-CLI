#!/bin/bash

# Define the installation path
INSTALL_PATH="/usr/local/bin"

# Copy the script to the installation path
cp upload_to_s3.sh $INSTALL_PATH/cloud-upload

# Ensure the script is executable
chmod +x $INSTALL_PATH/cloud-upload

# Provide feedback to the user
echo "cloud-upload has been installed to $INSTALL_PATH"
echo "You can now run the script using the command: cloud-upload"
