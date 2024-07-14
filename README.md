# Cloud Storage Upload Tool

A bash-based CLI tool that allows users to quickly upload files to a specified cloud storage solution, providing a seamless upload experience similar to popular storage services. This tool supports AWS S3 and includes features like file encryption, progress bar, and shareable link generation.

## Overview

This tool simplifies the process of uploading files to AWS S3. Users can encrypt files before upload, monitor upload progress, and generate shareable links for uploaded files. The script also handles file existence checks and offers options to overwrite, skip, or rename files.

## Prerequisites

1. **AWS CLI**: Ensure the AWS CLI is installed and configured on your system.
   - Installation guide: [AWS CLI Installation](https://docs.aws.amazon.com/cli/latest/userguide/getting-started-install.html)
   
2. **`pv` Command** (optional): For displaying a progress bar during the upload.
   - **Windows**: Use WSL or Cygwin to install `pv`.
   - **macOS**: `brew install pv`
   - **Debian/Ubuntu**: `sudo apt-get install pv`

3. **OpenSSL**: Required for file encryption.
   - **Windows**: Install OpenSSL for Windows.
   - **macOS/Linux**: OpenSSL is typically pre-installed.

## Setup 1

1. **Download the Archive**

   ```sh
   wget https://github.com/Mekazstan/CloudUploader-CLI/blob/main/cloud-storage-upload-tool.tar.gz
   or 
   Query https://github.com/Mekazstan/CloudUploader-CLI/blob/main/cloud-storage-upload-tool.tar.gz on your browser.

2. **Extract the Archive**

   ```sh
   tar -xzvf cloud-storage-upload-tool.tar.gz
    cd cloud-storage-upload-tool

3. **Run the Installation Script**

   ```sh
   sudo ./install.sh

4. **Create a `.env` File**

   ```sh
   cp .env.example .env
   nano .env  # Edit the file to add your AWS credentials and bucket name

5. **Add to `$PATH` (if necessary)**
    If /usr/local/bin is not in your $PATH, you can add it by modifying your shell's configuration file (~/.bashrc, ~/.zshrc, etc.):
   ```sh
   echo 'export PATH=$PATH:/usr/local/bin' >> ~/.bashrc
    source ~/.bashrc


## Setup 2

1. **Clone the repository**:
   ```sh
   git clone https://github.com/Mekazstan/CloudUploader-CLI.git
   cd CloudUploader-CLI

2. **Create a `.env` File**: 
   ```sh
    AWS_ACCESS_KEY_ID=your-access-key-id
    AWS_SECRET_ACCESS_KEY=your-secret-access-key
    AWS_DEFAULT_REGION=your-default-region
    S3_BUCKET_NAME=your-bucket-name

3. **Make the Script Executable**: 
   ```sh
   chmod +x upload_to_s3.sh

## Usage

    ``sh
    ./upload_to_s3.sh [-d target_directory] [-s storage_class] [-e] file_path


## Options
    - `-d target_directory: Specify the target cloud directory.
    - `-s storage_class: Specify the storage class (e.g., STANDARD, REDUCED_REDUNDANCY, etc.).
    - `-e: Enable encryption before upload.

### Examples

1. **Basic Upload**:
   ```sh
   ./upload_to_s3.sh sample.txt

2. **Upload with Encryption**:
   ```sh
   ./upload_to_s3.sh -e sample.txt

3. **Upload to a Specific Directory with a Different Storage Class**:
   ```sh
   ./upload_to_s3.sh -d my-directory -s REDUCED_REDUNDANCY sample.txt

## Troubleshooting

### Common Issues

1. **AWS CLI Not Found**:
    ```sh
    ./upload_to_s3.sh: line 15: aws: command not found
**Solution**: Ensure AWS CLI is installed and properly configured. Check your system's PATH variable.

2. **File Not Found**:
    ```sh
    File does not exist or is not accessible: sample.txt
**Solution**: Verify the file path and ensure the file exists.

3. **`pv` Command Not Found** (optional):
    ```sh
    ./upload_to_s3.sh: line 43: pv: command not found
**Solution**: Install `pv` using your package manager or use WSL/Cygwin on Windows.

4. **Upload Failed**:
    ```sh
    Failed to upload the file.
**Solution**: Check your AWS credentials, network connection, and ensure the target S3 bucket exists and you have the necessary permissions.

## Advanced Features

1. **Encryption**:
   Files can be encrypted using OpenSSL before upload. Use the `-e` flag to enable encryption. The script uses AES-256-CBC encryption.

2. **Progress Bar**:
   If `pv` is installed, the script will display a progress bar during the upload.

3. **Shareable Link Generation**:
   After a successful upload, the script generates a presigned URL valid for 7 days.

4. **File Existence Handling**:
   If the file already exists in the target S3 bucket, the script offers options to overwrite, skip, or rename the file.

5. **Error Handling**:
   The script provides meaningful error messages for common issues and handles different types of input validation.

## Contributing

Feel free to submit issues and pull requests to improve the tool.
