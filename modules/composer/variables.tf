variable "project_id" {
  description = "GCP Project ID"
  type        = string
}
variable "project_number" {
  description = "GCP Project Number"
  type        = string
}
variable "region" {
  description = "Region for the Composer environment"
  type        = string
}
variable "vpc_self_link" {
  description = "The self-link of the VPC network"
  type        = string
}
variable "composer_subnet_self_link" {
  description = "The self-link of the Composer subnet"
  type        = string
}
variable "composer_subnet_cidr" {
  description = "The IP range of the Composer subnet"
  type        = string
}
variable "composer_sql_cidr" {
  description = "A new, non-overlapping IP range for the Composer SQL DB"
  type        = string
  default     = "10.70.0.0/24" # Must not overlap with any other subnet
}
variable "environment_size" {
  description = "The size of the Composer environment (SMALL, MEDIUM, LARGE)"
  type        = string
  default     = "ENVIRONMENT_SIZE_SMALL"
}
variable "airflow_image_version" {
  description = "The Composer image version to use"
  type        = string
  # Find the latest version here: https://cloud.google.com/composer/docs/concepts/versioning/composer-versions
  default     = "composer-3-airflow-3.1.0"
}
variable "bigquery_kms_key_id" {
  description = "The full ID of the BigQuery KMS key"
  type        = string
}
variable "storage_kms_key_id" {
  description = "The full ID of the Storage KMS key"
  type        = string
}