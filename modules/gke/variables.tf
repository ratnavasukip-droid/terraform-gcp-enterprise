variable "project_id" {
  description = "GCP Project ID"
  type        = string
}
variable "region" {
  description = "Region for the GKE cluster"
  type        = string
}
variable "vpc_self_link" {
  description = "The self-link of the VPC network"
  type        = string
}
variable "gke_subnet_self_link" {
  description = "The self-link of the GKE subnet"
  type        = string
}