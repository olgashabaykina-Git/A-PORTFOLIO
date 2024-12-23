# AWS Static Website Hosting with Terraform

This repository contains Terraform code to deploy a simple static website on AWS using Amazon S3 and CloudFront. 
The infrastructure is automated and reproducible, ensuring efficient deployment and management.

## Overview

This project sets up:
1. An **Amazon S3 bucket** to store static content.
2. **CloudFront** as a Content Delivery Network (CDN) to serve content globally with low latency.
3. Secure access between CloudFront and S3 using **Origin Access Identity (OAI)**.
4. Policies to restrict public access to S3 and enforce secure delivery through CloudFront.

## Features

- **Automated Infrastructure Deployment**: Using Terraform for consistent and reproducible infrastructure as code (IaC).
- **Static Content Hosting**: S3 serves as the storage backend for static HTML files.
- **Global Content Delivery**: CloudFront reduces latency with edge locations.
- **Secure Access**: Only CloudFront can access the S3 bucket using OAI.
- **HTTPS Support**: Default SSL certificates for secure content delivery.

## Prerequisites

- [Terraform](https://developer.hashicorp.com/terraform/install) installed.
- An AWS account with appropriate permissions to create S3 buckets, CloudFront distributions, and policies.
- AWS credentials configured locally (`~/.aws/credentials` or environment variables).

## Usage

1. **Clone the Repository**:
   ```bash
   git clone https://github.com/olgashabaykina-Git/A-PORTFOLIO.git
   cd aws-hello-world
    ```
2. **Initialize Terraform**:
```bash
terraform init
 ```

3. **Apply the Terraform Configuration**:
```bash
terraform apply
 ```
Review the plan and type yes to confirm.
4.**Access the Website: After deployment, the output will display the CloudFront URL. Visit the URL in your browser to see static website**.

## Key Resources

- S3 Bucket
Stores the static content (index.html).
Public access is blocked to ensure secure delivery through CloudFront.
- CloudFront Distribution
Caches and delivers the static content globally.
Configured with OAI to securely fetch content from S3.
Origin Access Identity (OAI)
Grants CloudFront exclusive access to the S3 bucket.
- Terraform Outputs
Outputs the CloudFront distribution URL to access the deployed website.

## Clean Up
```bash
terraform destroy
 ```





