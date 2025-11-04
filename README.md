# GCP Enterprise Data Platform

This repository contains Terraform configurations for setting up an enterprise-grade data platform on Google Cloud Platform (GCP).

## Architecture

The infrastructure includes:

- **Data Storage**
  - Raw data bucket (landing zone)
  - Processed data bucket
  - Archive bucket
  - Logs bucket
  - All buckets configured with CMEK encryption

- **Data Warehouse**
  - Raw data dataset
  - Analytics dataset
  - ML Features dataset
  - Logging dataset
  - All datasets configured with CMEK encryption

- **Processing**
  - Cloud Composer (Airflow) environment
  - Google Kubernetes Engine (GKE) cluster

- **Security**
  - Customer Managed Encryption Keys (CMEK)
  - VPC with private subnets
  - IAM role-based access control
  - Service account separation

## Project Structure

```
environments/
  ├── dev/      # Development environment
  ├── prod/     # Production environment
  └── stage/    # Staging environment

modules/
  ├── bigquery/  # BigQuery datasets and IAM
  ├── composer/  # Cloud Composer (Airflow) environment
  ├── gke/       # Google Kubernetes Engine cluster
  ├── iam/       # Identity and Access Management
  ├── kms/       # Key Management Service
  ├── project/   # Project creation and API enablement
  └── storage/   # Cloud Storage buckets
```

## Prerequisites

1. Google Cloud Platform account with billing enabled
2. Terraform >= 1.5.0
3. `gcloud` CLI tool installed and configured
4. Required GCP APIs enabled
5. Service account with necessary permissions

## Usage

1. Navigate to the desired environment directory:
   ```bash
   cd environments/dev
   ```

2. Initialize Terraform:
   ```bash
   terraform init
   ```

3. Review the planned changes:
   ```bash
   terraform plan
   ```

4. Apply the configuration:
   ```bash
   terraform apply
   ```

## Security Notes

- All data at rest is encrypted using Customer Managed Encryption Keys (CMEK)
- Network access is restricted using VPC and firewall rules
- Service accounts follow the principle of least privilege
- Audit logging is enabled and configured to track all access

## Contributing

1. Create a feature branch
2. Make your changes
3. Submit a pull request

## License

This project is proprietary and confidential.