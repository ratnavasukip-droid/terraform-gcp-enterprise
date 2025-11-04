output "logs_dataset_id" {
  description = "ID of the logs dataset"
  value       = google_bigquery_dataset.logs.dataset_id
}

output "storage_log_sink_name" {
  description = "Name of storage log sink"
  value       = google_logging_project_sink.storage_logs.name
}

output "bigquery_log_sink_name" {
  description = "Name of BigQuery log sink"
  value       = google_logging_project_sink.bigquery_logs.name
}

output "iam_log_sink_name" {
  description = "Name of IAM log sink"
  value       = google_logging_project_sink.iam_logs.name
}

output "error_log_sink_name" {
  description = "Name of error log sink"
  value       = google_logging_project_sink.error_logs.name
}
