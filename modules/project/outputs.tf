# Output values that other modules can reference
# Outputs are how modules "return" values

output "project_id" {
  description = "The created project ID"
  value       = google_project.project.project_id
}

output "project_number" {
  description = "The project number (used for some IAM operations)"
  value       = google_project.project.number
}

output "project_name" {
  description = "The project name"
  value       = google_project.project.name
}

output "terraform_service_account_email" {
  description = "Email of the Terraform service account"
  value       = google_service_account.terraform_sa.email
}

output "enabled_apis" {
  description = "List of enabled APIs"
  value       = var.enabled_apis
}
