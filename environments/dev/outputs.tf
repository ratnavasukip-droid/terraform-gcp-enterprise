output "project_id" {
  description = "Created project ID"
  value       = module.project.project_id
}

output "project_number" {
  description = "Project number"
  value       = module.project.project_number
}

output "terraform_service_account" {
  description = "Terraform service account email"
  value       = module.project.terraform_service_account_email
}
# ... (keep existing outputs)

# KMS outputs
output "kms_key_ring_id" {
  description = "KMS Key Ring ID"
  value       = module.kms.key_ring_id
}

output "storage_encryption_key" {
  description = "Storage encryption key ID"
  value       = module.kms.storage_key_id
}

output "bigquery_encryption_key" {
  description = "BigQuery encryption key ID"
  value       = module.kms.bigquery_key_id
}
# ... (keep existing outputs)

# Storage outputs
output "raw_data_bucket" {
  description = "Raw data bucket name"
  value       = module.storage.raw_data_bucket_name
}

output "processed_data_bucket" {
  description = "Processed data bucket name"
  value       = module.storage.processed_data_bucket_name
}

output "archive_bucket" {
  description = "Archive bucket name"
  value       = module.storage.archive_bucket_name
}

output "logs_bucket" {
  description = "Logs bucket name"
  value       = module.storage.logs_bucket_name
}

output "all_buckets" {
  description = "All bucket names"
  value       = module.storage.all_bucket_names
}


# ... (keep existing outputs)

# BigQuery outputs
output "raw_data_dataset" {
  description = "Raw data dataset ID"
  value       = module.bigquery.raw_data_dataset_id
}

output "analytics_dataset" {
  description = "Analytics dataset ID"
  value       = module.bigquery.analytics_dataset_id
}

output "ml_features_dataset" {
  description = "ML features dataset ID"
  value       = module.bigquery.ml_features_dataset_id
}

output "all_datasets" {
  description = "All BigQuery dataset IDs"
  value       = module.bigquery.all_dataset_ids
}


# ... (keep existing outputs)

# Logging outputs
output "logs_dataset" {
  description = "Logs dataset ID"
  value       = module.logging.logs_dataset_id
}

output "log_sinks" {
  description = "Created log sinks"
  value = {
    storage  = module.logging.storage_log_sink_name
    bigquery = module.logging.bigquery_log_sink_name
    iam      = module.logging.iam_log_sink_name
    errors   = module.logging.error_log_sink_name
  }
}
# ... (all other outputs)

# Networking outputs
output "vpc_name" {
  value = module.networking.vpc_name
}
output "composer_subnet" {
  value = module.networking.composer_subnet_self_link
}
output "gke_subnet" {
  value = module.networking.gke_subnet_self_link
}

# ... (all other outputs)
# ... (all other outputs)

# GKE outputs
output "gke_cluster_name" {
  value = module.gke.cluster_name
}
output "gke_cluster_endpoint" {
  value     = module.gke.cluster_endpoint
  sensitive = true
}
# Composer outputs
output "composer_airflow_url" {
  description = "URL for the Airflow UI"
  value       = module.composer.airflow_uri
  sensitive   = true
}
output "composer_dags_bucket" {
  description = "GCS bucket to upload DAGs to"
  value       = module.composer.gcs_dag_bucket
}