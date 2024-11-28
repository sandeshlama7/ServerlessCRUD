# Serverless CRUD Application Deployment Guide

This repository contains a simple **Serverless CRUD Application** deployed using **Terraform** and **AWS SAM**. Follow the steps below to provision and deploy the necessary resources.

---

## Prerequisites

- **Terraform** installed on your local system.
- **AWS CLI** configured with necessary permissions.
- **SAM CLI** installed and configured.
- An S3 bucket for storing the Terraform state file and staging SAM templates.
- A DynamoDB table for Terraform state locking (recommended).

---

## Deployment Steps

### Step 1: Clone the Repository
`git clone git@github.com:sandeshlama7/ServerlessCRUD.git`

### Step 2: Change into the Terraform directory
`cd Terraform`

### Step 3: Change the backend configuration.
Provide the name of the S3 bucket to store the terraform state file. If you want to store the state file locally, you can delete the backend.tf file. Although, it is recommended to use S3 as backend and DynamoDB for state locking.

### Step 4: Initialize Terraform
`terraform init`

### Step 5: Check the Terraform plan
`terraform plan -var-file dev.tfvars`
Note that there are two .tfvars file, namely, dev.tfvars and prod.tfvars for multi-environment deployment. You can use any here.

### Step 6: Apply Terraform to provision the resources
`terraform apply -var-file dev.tfvars`

### Step 7: Note the Terraform outputs when apply is completed.
You can look at the output values with the following command as well.
`terraform output`
### Step 8: After resources have been provisioned by Terraform, Change into the SAM directory to deploy the serverless resources.

### Step 9: Update the s3_bucket in samconfig.toml
Provide your S3 bucket for staging the build cloudformation template

### Step 10: Update the necessary parameters in template.yml file by using the terraform outputs that you noted earlier.
Provide the correct values for LambdaSG (lambda security group id), PrivateSubnetIds (Private Subnet Id), RDSHOST (RDS Endpoint), SECRET (Secrets Manager Secret arn/id), DOMAIN (domain name).

### Step 11: (Optional) Package the sam template
`sam package --s3-bucket <bucket_name>`

### Step 12: Deploy SAM application
`sam deploy --config-file samconfig.toml --config-env development`

### Step 13: Note the SAM output for ApiInvokeUrl.
Inside the client directory, create a .env file and add the following:
`REACT_APP_BASE_URL=<ApiInvokeUrl>`

### Step 14: Build the react application
`npm run build`

### Step 15: Copy the contents of the build directory into the S3 bucket
`aws s3 cp client/build/ s3://$S3BUCKET/ --recursive`

Following this guide, you will have successfully deployed a simple Serverless CRUD Application by using Terraform and SAM. You can change the configuration values for terraform resources from the .tfvars files. Likewise, github actions workflow has been added to automate the development and deployment process.
