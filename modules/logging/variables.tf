variable "project_id" {
  description = "GCP Project ID"
  type        = string
}

variable "region" {
  description = "Region for log dataset"
  type        = string
}

variable "environment" {
  description = "Environment (dev, stage, prod)"
  type        = string
}

variable "dataset_prefix" {
  description = "Prefix for dataset name"
  type        = string
  default     = "platform"
}

variable "kms_key_id" {
  description = "KMS key for encrypting logs"
  type        = string
}

variable "labels" {
  description = "Labels to apply"
  type        = map(string)
  default     = {}
}
