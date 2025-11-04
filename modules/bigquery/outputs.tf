output "raw_data_dataset_id" {
  description = "ID of the raw data dataset"
  value       = google_bigquery_dataset.raw_data.dataset_id
}

output "analytics_dataset_id" {
  description = "ID of the analytics dataset"
  value       = google_bigquery_dataset.analytics.dataset_id
}

output "ml_features_dataset_id" {
  description = "ID of the ML features dataset"
  value       = google_bigquery_dataset.ml_features.dataset_id
}

output "raw_data_dataset_reference" {
  description = "Full reference to raw data dataset"
  value       = "${var.project_id}.${google_bigquery_dataset.raw_data.dataset_id}"
}

output "analytics_dataset_reference" {
  description = "Full reference to analytics dataset"
  value       = "${var.project_id}.${google_bigquery_dataset.analytics.dataset_id}"
}

output "ml_features_dataset_reference" {
  description = "Full reference to ML features dataset"
  value       = "${var.project_id}.${google_bigquery_dataset.ml_features.dataset_id}"
}

output "all_dataset_ids" {
  description = "List of all dataset IDs"
  value = [
    google_bigquery_dataset.raw_data.dataset_id,
    google_bigquery_dataset.analytics.dataset_id,
    google_bigquery_dataset.ml_features.dataset_id
  ]
}
