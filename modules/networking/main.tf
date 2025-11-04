# Create a custom Virtual Private Cloud (VPC)
resource "google_compute_network" "vpc" {
  name                    = "${var.project_id}-vpc"
  project                 = var.project_id
  auto_create_subnetworks = false # We will create subnets manually for control
  routing_mode            = "REGIONAL"
}

# Create a subnet for Cloud Composer
resource "google_compute_subnetwork" "composer_subnet" {
  name                     = "${var.project_id}-snet-composer"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = var.composer_subnet_cidr
  private_ip_google_access = true # Allows VMs to reach Google APIs (like BigQuery) privately

  # Composer requires these two secondary ranges
  secondary_ip_range {
    range_name    = "composer-pods"
    ip_cidr_range = var.composer_pods_cidr
  }
  secondary_ip_range {
    range_name    = "composer-services"
    ip_cidr_range = var.composer_services_cidr
  }
}

# Create a subnet for GKE
resource "google_compute_subnetwork" "gke_subnet" {
  name                     = "${var.project_id}-snet-gke"
  project                  = var.project_id
  region                   = var.region
  network                  = google_compute_network.vpc.id
  ip_cidr_range            = var.gke_subnet_cidr
  private_ip_google_access = true

  # GKE requires these two secondary ranges
  secondary_ip_range {
    range_name    = "gke-pods"
    ip_cidr_range = var.gke_pods_cidr
  }
  secondary_ip_range {
    range_name    = "gke-services"
    ip_cidr_range = var.gke_services_cidr
  }
}

# Firewall Rule: Allow internal traffic within the VPC
resource "google_compute_firewall" "allow_internal" {
  name    = "${google_compute_network.vpc.name}-allow-internal"
  project = var.project_id
  network = google_compute_network.vpc.id
  
  # Allow traffic from any source IP within our VPC subnets
  source_ranges = [
    var.composer_subnet_cidr,
    var.gke_subnet_cidr
  ]

  # Allow all protocols (tcp, udp, icmp)
  allow {
    protocol = "all"
  }
}

# Firewall Rule: Allow SSH (port 22) from anywhere
# In production, you would restrict source_ranges to your office/VPN IP
resource "google_compute_firewall" "allow_ssh" {
  name    = "${google_compute_network.vpc.name}-allow-ssh"
  project = var.project_id
  network = google_compute_network.vpc.id
  
  # WARNING: 0.0.0.0/0 is "anywhere". Not secure for prod.
  source_ranges = ["0.0.0.0/0"] 

  allow {
    protocol = "tcp"
    ports    = ["22"]
  }
}