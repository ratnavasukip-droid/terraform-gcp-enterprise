# This module creates a GCP project and enables necessary APIs

# Create a random ID to make project IDs unique
# GCP project IDs must be globally unique across ALL of Google Cloud
resource "random_id" "project_id" {
  byte_length = 4
}

# Create the GCP project
resource "google_project" "project" {
  # Project name (human-readable, can have spaces)
  name = var.project_name
  
  # Project ID (unique identifier, lowercase, hyphens only)
  # We append random_id to ensure uniqueness
  project_id = "${var.project_id}-${random_id.project_id.hex}"
  
  # Billing account ID (required for resource creation)
  billing_account = var.billing_account
  
  # Labels for organization (useful for cost tracking, compliance)
  labels = {
    environment = var.environment
    team        = var.team
    managed_by  = "terraform"
  }
}

# Enable required GCP APIs
# APIs must be enabled before you can create resources
resource "google_project_service" "required_apis" {
  # Create one API enablement per API in the list
  for_each = toset(var.enabled_apis)
  
  project = google_project.project.project_id
  service = each.value
  
  # Don't disable APIs when Terraform destroys (prevents data loss)
  disable_on_destroy = false
  
  # Wait for API to be fully enabled before continuing
  disable_dependent_services = false
}

# Create a default service account for Terraform operations
# Service accounts are like "robot users" for automation
resource "google_service_account" "terraform_sa" {
  account_id   = "terraform-automation"
  display_name = "Terraform Automation Service Account"
  description  = "Service account used by Terraform for infrastructure provisioning"
  project      = google_project.project.project_id
  
  depends_on = [google_project_service.required_apis]
}

# Grant the service account Project Editor role
# WARNING: In production, use more restrictive roles
resource "google_project_iam_member" "terraform_sa_editor" {
  project = google_project.project.project_id
  role    = "roles/editor"
  member  = "serviceAccount:${google_service_account.terraform_sa.email}"
}
