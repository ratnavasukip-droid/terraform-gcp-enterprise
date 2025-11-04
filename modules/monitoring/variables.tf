variable "project_id" {
  description = "GCP project id where monitoring resources will be created"
  type        = string
}

variable "cluster_name" {
  description = "Name of the GKE cluster to target for alerts/dashboards"
  type        = string
}

variable "notification_email" {
  description = "Email address to receive alerts"
  type        = string
}

variable "labels" {
  description = "Optional labels"
  type        = map(string)
  default     = {}
}
