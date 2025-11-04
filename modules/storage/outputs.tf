output "raw_data_bucket_name" {
  description = "Name of the raw data bucket"
  value       = google_storage_bucket.raw_data.name
}

output "raw_data_bucket_url" {
  description = "URL of the raw data bucket"
  value       = google_storage_bucket.raw_data.url
}

output "processed_data_bucket_name" {
  description = "Name of the processed data bucket"
  value       = google_storage_bucket.processed_data.name
}

output "processed_data_bucket_url" {
  description = "URL of the processed data bucket"
  value       = google_storage_bucket.processed_data.url
}

output "archive_bucket_name" {
  description = "Name of the archive bucket"
  value       = google_storage_bucket.archive.name
}

output "archive_bucket_url" {
  description = "URL of the archive bucket"
  value       = google_storage_bucket.archive.url
}

output "logs_bucket_name" {
  description = "Name of the logs bucket"
  value       = google_storage_bucket.logs.name
}

output "logs_bucket_url" {
  description = "URL of the logs bucket"
  value       = google_storage_bucket.logs.url
}

output "all_bucket_names" {
  description = "List of all bucket names"
  value = [
    google_storage_bucket.raw_data.name,
    google_storage_bucket.processed_data.name,
    google_storage_bucket.archive.name,
    google_storage_bucket.logs.name
  ]
}
