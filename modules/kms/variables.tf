variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_number" {
  description = "GCP Project Number (for service account IAM)"
  type        = string
}

variable "region" {
  description = "Region for the key ring"
  type        = string
}

variable "key_ring_name" {
  description = "Name of the KMS key ring"
  type        = string
  default     = "enterprise-keyring"
}

variable "storage_key_name" {
  description = "Name of the storage encryption key"
  type        = string
  default     = "storage-encryption-key"
}

variable "bigquery_key_name" {
  description = "Name of the BigQuery encryption key"
  type        = string
  default     = "bigquery-encryption-key"
}

variable "rotation_period" {
  description = "Key rotation period (seconds). 90 days = 7776000s"
  type        = string
  default     = "7776000s"  # 90 days
}

variable "protection_level" {
  description = "Protection level for keys (SOFTWARE or HSM)"
  type        = string
  default     = "SOFTWARE"
  
  validation {
    condition     = contains(["SOFTWARE", "HSM"], var.protection_level)
    error_message = "Protection level must be SOFTWARE or HSM."
  }
}

variable "labels" {
  description = "Labels to apply to KMS resources"
  type        = map(string)
  default     = {}
}
