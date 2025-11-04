# Input variables for the project module
# Variables make modules reusable with different values

variable "project_name" {
  description = "Human-readable project name"
  type        = string
}

variable "project_id" {
  description = "Base project ID (will be made unique)"
  type        = string
  
  # Validation ensures project IDs follow GCP rules
  validation {
    condition     = can(regex("^[a-z][a-z0-9-]{4,28}[a-z0-9]$", var.project_id))
    error_message = "Project ID must be 6-30 characters, lowercase letters, digits, hyphens. Must start with letter."
  }
}

variable "billing_account" {
  description = "Billing account ID to link to project"
  type        = string
}

variable "environment" {
  description = "Environment name (dev, stage, prod)"
  type        = string
  
  validation {
    condition     = contains(["dev", "stage", "prod"], var.environment)
    error_message = "Environment must be dev, stage, or prod."
  }
}

variable "team" {
  description = "Team responsible for this project"
  type        = string
  default     = "data-engineering"
}

variable "enabled_apis" {
  description = "List of GCP APIs to enable"
  type        = list(string)
  default = [
    "compute.googleapis.com",              # Compute Engine (needed for GKE nodes)
    "storage.googleapis.com",              # Cloud Storage
    "bigquery.googleapis.com",             # BigQuery
    "composer.googleapis.com",             # Cloud Composer
    "container.googleapis.com",            # GKE
    "cloudkms.googleapis.com",             # Cloud KMS
    "iam.googleapis.com",                  # IAM
    "cloudresourcemanager.googleapis.com", # Resource Manager
    "servicenetworking.googleapis.com",    # Service Networking (for Composer)
    "sqladmin.googleapis.com",             # Cloud SQL (Composer dependency)
  ]
}

variable "org_id" {
  description = "Organization ID (optional)"
  type        = string
  default     = ""
}
