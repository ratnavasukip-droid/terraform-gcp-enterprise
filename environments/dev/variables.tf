variable "project_name" {
  description = "Human-readable project name"
  type        = string
  default     = "Data Platform Dev"
}

variable "project_id_base" {
  description = "Base project ID (random suffix will be added)"
  type        = string
  default     = "data-platform-dev"
}

variable "billing_account" {
  description = "Billing account ID"
  type        = string
  # You'll provide this in terraform.tfvars
}

variable "region" {
  description = "Default GCP region"
  type        = string
  default     = "us-central1"  # Iowa - low cost, good for dev
}

variable "zone" {
  description = "Default GCP zone"
  type        = string
  default     = "us-central1-a"
}

# ... (keep existing variables)

variable "owner_email" {
  description = "Email address of the infrastructure owner"
  type        = string
}
