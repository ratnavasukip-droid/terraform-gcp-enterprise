output "key_ring_id" {
  description = "ID of the KMS key ring"
  value       = google_kms_key_ring.key_ring.id
}

output "key_ring_name" {
  description = "Name of the KMS key ring"
  value       = google_kms_key_ring.key_ring.name
}

output "storage_key_id" {
  description = "ID of the storage encryption key"
  value       = google_kms_crypto_key.storage_key.id
}

output "storage_key_name" {
  description = "Name of the storage encryption key"
  value       = google_kms_crypto_key.storage_key.name
}

output "bigquery_key_id" {
  description = "ID of the BigQuery encryption key"
  value       = google_kms_crypto_key.bigquery_key.id
}

output "bigquery_key_name" {
  description = "Name of the BigQuery encryption key"
  value       = google_kms_crypto_key.bigquery_key.name
}
