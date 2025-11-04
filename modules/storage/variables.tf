variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "project_number" {
  description = "GCP Project Number"
  type        = string
}

variable "region" {
  description = "GCP region for buckets"
  type        = string
}

variable "environment" {
  description = "Environment (dev, stage, prod)"
  type        = string
}

variable "kms_key_id" {
  description = "KMS key ID for bucket encryption"
  type        = string
}

variable "force_destroy" {
  description = "Allow bucket deletion even if not empty (use false in production)"
  type        = bool
  default     = true  # true for dev, false for prod
}

variable "labels" {
  description = "Labels to apply to buckets"
  type        = map(string)
  default     = {}
}
