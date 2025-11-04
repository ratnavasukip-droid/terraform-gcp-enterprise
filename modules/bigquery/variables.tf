variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_number" {
  description = "GCP Project Number"
  type        = string
}

variable "region" {
  description = "Region for datasets"
  type        = string
}

variable "environment" {
  description = "Environment (dev, stage, prod)"
  type        = string
}

variable "dataset_prefix" {
  description = "Prefix for dataset names"
  type        = string
  default     = "data_platform"
}

variable "kms_key_id" {
  description = "KMS key ID for dataset encryption"
  type        = string
}

variable "owner_email" {
  description = "Email of dataset owner"
  type        = string
}

variable "default_table_expiration_ms" {
  description = "Default table expiration in milliseconds (90 days = 7776000000)"
  type        = number
  default     = 7776000000  # 90 days
}

variable "delete_contents_on_destroy" {
  description = "Delete dataset contents when destroying (true for dev, false for prod)"
  type        = bool
  default     = true
}

variable "labels" {
  description = "Labels to apply to datasets"
  type        = map(string)
  default     = {}
}

# IAM members (in real scenario, these would be AD groups)
variable "data_engineers_group" {
  description = "Data engineers group (e.g., group:data-engineers@company.com)"
  type        = string
  default     = "user:your-email@example.com"  # Will override in environments
}

variable "data_analysts_group" {
  description = "Data analysts group"
  type        = string
  default     = "user:your-email@example.com"
}

variable "data_scientists_group" {
  description = "Data scientists group"
  type        = string
  default     = "user:your-email@example.com"
}
