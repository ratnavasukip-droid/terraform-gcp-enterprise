variable "project_id" {
  description = "GCP Project ID"
  type        = string
}
variable "region" {
  description = "Region for VPC and subnets"
  type        = string
}

# CIDR Blocks for Composer
variable "composer_subnet_cidr" {
  description = "IP range for Composer subnet"
  type        = string
  default     = "10.10.0.0/24"
}
variable "composer_pods_cidr" {
  description = "IP range for Composer GKE pods"
  type        = string
  default     = "10.20.0.0/20"
}
variable "composer_services_cidr" {
  description = "IP range for Composer GKE services"
  type        = string
  default     = "10.30.0.0/24"
}

# CIDR Blocks for GKE
variable "gke_subnet_cidr" {
  description = "IP range for main GKE subnet"
  type        = string
  default     = "10.40.0.0/24"
}
variable "gke_pods_cidr" {
  description = "IP range for GKE pods"
  type        = string
  default     = "10.50.0.0/20"
}
variable "gke_services_cidr" {
  description = "IP range for GKE services"
  type        = string
  default     = "10.60.0.0/24"
}