output "vpc_name" {
  description = "The name of the created VPC"
  value       = google_compute_network.vpc.name
}
output "vpc_self_link" {
  description = "The self-link of the created VPC"
  value       = google_compute_network.vpc.self_link
}
output "composer_subnet_self_link" {
  description = "The self-link of the Composer subnet"
  value       = google_compute_subnetwork.composer_subnet.self_link
}
output "gke_subnet_self_link" {
  description = "The self-link of the GKE subnet"
  value       = google_compute_subnetwork.gke_subnet.self_link
}

# ... (existing outputs)

output "composer_subnet_cidr" {
  description = "The CIDR range of the Composer subnet"
  value       = google_compute_subnetwork.composer_subnet.ip_cidr_range
}