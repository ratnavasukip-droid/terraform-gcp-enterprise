# Create a GKE (Google Kubernetes Engine) cluster
resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke-cluster"
  project  = var.project_id
  location = var.region
  initial_node_count = 1

  # Connect to our VPC and GKE subnet
  network    = var.vpc_self_link
  subnetwork = var.gke_subnet_self_link

  # Use the IP ranges we defined in our networking module
  ip_allocation_policy {
    cluster_secondary_range_name  = "gke-pods"
    services_secondary_range_name = "gke-services"
  }

  # This is a private cluster. Nodes do not have public IPs.
  # This is a major security best practice.
  private_cluster_config {
    enable_private_nodes    = true
    enable_private_endpoint = false # Keep endpoint public for our access
    master_ipv4_cidr_block  = "172.16.0.0/28" # A new, required range
  }

  # Use Workload Identity - the most secure way to access other GCP services
  workload_identity_config {
    workload_pool = "${var.project_id}.svc.id.goog"
  }

  # Define the node pools (the VMs that run our containers)
  node_config {
    # Use our custom service account
    service_account = google_service_account.gke_sa.email
    oauth_scopes = [
      "https://www.googleapis.com/auth/cloud-platform"
    ]
    disk_type    = "pd-standard"  # Use standard disks, not SSD
    disk_size_gb = 30             # Use 30GB disks (default is 100)
  }

  # Enable basic features
  master_auth {
    client_certificate_config {
      issue_client_certificate = false
    }
  }

  # This creates the service account *before* the cluster
  depends_on = [
    google_service_account.gke_sa
  ]
}

# --- Service Account & IAM ---
# Create a dedicated service account for our GKE nodes
resource "google_service_account" "gke_sa" {
  account_id   = "gke-node-sa"
  display_name = "GKE Node Service Account"
  project      = var.project_id
}

# Grant GKE nodes basic permissions
resource "google_project_iam_member" "gke_monitoring" {
  project = var.project_id
  role    = "roles/monitoring.metricWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}
resource "google_project_iam_member" "gke_logging" {
  project = var.project_id
  role    = "roles/logging.logWriter"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}

# This is for Workload Identity: Allow Kubernetes SAs to impersonate GCP SAs
# We will grant this to a *different* SA we'll create later for our apps
resource "google_project_iam_member" "gke_workload_identity_user" {
  project = var.project_id
  role    = "roles/iam.workloadIdentityUser"
  member  = "serviceAccount:${google_service_account.gke_sa.email}"
}