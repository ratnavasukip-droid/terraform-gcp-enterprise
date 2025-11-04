output "environment_name" {
  description = "The name of the Cloud Composer environment"
  value       = google_composer_environment.composer.name
}

output "airflow_uri" {
  description = "The URI of the Airflow web interface"
  value       = google_composer_environment.composer.config[0].airflow_uri
}

output "gcs_dag_bucket" {
  description = "The GCS bucket where DAGs should be uploaded"
  value       = google_composer_environment.composer.config[0].dag_gcs_prefix
}