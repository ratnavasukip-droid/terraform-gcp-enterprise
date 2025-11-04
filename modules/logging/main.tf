# Logging Module - Export logs to BigQuery

# Create BigQuery dataset for logs
resource "google_bigquery_dataset" "logs" {
  dataset_id  = "${var.dataset_prefix}_logs_${var.environment}"
  project     = var.project_id
  location    = var.region
  description = "Centralized logs from all GCP services"
  
  # Keep logs for 90 days, then auto-delete
  default_table_expiration_ms = 7776000000  # 90 days
  
  # Logs are sensitive, use CMEK
  default_encryption_configuration {
    kms_key_name = var.kms_key_id
  }
  
  labels = merge(
    var.labels,
    {
      dataset_type = "logs"
      data_zone    = "observability"
    }
  )
}

# Log Sink: All Cloud Storage access logs → BigQuery
resource "google_logging_project_sink" "storage_logs" {
  name        = "storage-access-logs-to-bigquery"
  project     = var.project_id
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs.dataset_id}"
  
  # Filter: Only GCS access logs
  filter = <<-EOT
    resource.type = "gcs_bucket"
    protoPayload.methodName =~ "storage.objects.*"
  EOT
  
  # Create tables automatically
  bigquery_options {
    use_partitioned_tables = true
  }
  
  # Required for BigQuery destination
  unique_writer_identity = true
}

# Grant log sink permission to write to BigQuery
resource "google_bigquery_dataset_iam_member" "log_writer_storage" {
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.storage_logs.writer_identity
  project    = var.project_id
}

# Log Sink: All BigQuery job logs → BigQuery
resource "google_logging_project_sink" "bigquery_logs" {
  name        = "bigquery-job-logs-to-bigquery"
  project     = var.project_id
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs.dataset_id}"
  
  # Filter: BigQuery query jobs
  filter = <<-EOT
    resource.type = "bigquery_project"
    protoPayload.methodName = "jobservice.jobcompleted"
  EOT
  
  bigquery_options {
    use_partitioned_tables = true
  }
  
  unique_writer_identity = true
}

# Grant log sink permission
resource "google_bigquery_dataset_iam_member" "log_writer_bigquery" {
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.bigquery_logs.writer_identity
  project    = var.project_id
}

# Log Sink: All IAM changes → BigQuery
resource "google_logging_project_sink" "iam_logs" {
  name        = "iam-audit-logs-to-bigquery"
  project     = var.project_id
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs.dataset_id}"
  
  # Filter: IAM policy changes
  filter = <<-EOT
    protoPayload.methodName = "SetIamPolicy"
    OR protoPayload.serviceName = "iam.googleapis.com"
  EOT
  
  bigquery_options {
    use_partitioned_tables = true
  }
  
  unique_writer_identity = true
}

# Grant log sink permission
resource "google_bigquery_dataset_iam_member" "log_writer_iam" {
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.iam_logs.writer_identity
  project    = var.project_id
}

# Log Sink: All error logs → BigQuery
resource "google_logging_project_sink" "error_logs" {
  name        = "error-logs-to-bigquery"
  project     = var.project_id
  destination = "bigquery.googleapis.com/projects/${var.project_id}/datasets/${google_bigquery_dataset.logs.dataset_id}"
  
  # Filter: Only errors and critical logs
  filter = <<-EOT
    severity >= ERROR
  EOT
  
  bigquery_options {
    use_partitioned_tables = true
  }
  
  unique_writer_identity = true
}

# Grant log sink permission
resource "google_bigquery_dataset_iam_member" "log_writer_error" {
  dataset_id = google_bigquery_dataset.logs.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = google_logging_project_sink.error_logs.writer_identity
  project    = var.project_id
}

# Grant the logging sink writer identities permission to use the KMS key
# Required when the BigQuery dataset is encrypted with a customer-managed key (CMEK)
resource "google_kms_crypto_key_iam_member" "storage_sink_kms" {
  crypto_key_id = var.kms_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = google_logging_project_sink.storage_logs.writer_identity
}

resource "google_kms_crypto_key_iam_member" "bigquery_sink_kms" {
  crypto_key_id = var.kms_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = google_logging_project_sink.bigquery_logs.writer_identity
}

resource "google_kms_crypto_key_iam_member" "iam_sink_kms" {
  crypto_key_id = var.kms_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = google_logging_project_sink.iam_logs.writer_identity
}

resource "google_kms_crypto_key_iam_member" "error_sink_kms" {
  crypto_key_id = var.kms_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = google_logging_project_sink.error_logs.writer_identity
}

# Create view for BigQuery cost analysis
# resource "google_bigquery_table" "bigquery_cost_view" {
#   dataset_id = google_bigquery_dataset.logs.dataset_id
#   table_id   = "bigquery_cost_analysis"
#   project    = var.project_id
  
#   view {
    # query = <<-EOT
    #   SELECT
        # TIMESTAMP_TRUNC(timestamp, DAY) as date,
        # protopayload_auditlog.authenticationInfo.principalEmail as user,
        # protopayload_auditlog.servicedata_v1_bigquery.jobCompletedEvent.job.jobStatistics.totalBilledBytes / POW(10, 12) as tb_billed,
        # (protopayload_auditlog.servicedata_v1_bigquery.jobCompletedEvent.job.jobStatistics.totalBilledBytes / POW(10, 12)) * 5 as estimated_cost_usd,
        # protopayload_auditlog.servicedata_v1_bigquery.jobCompletedEvent.job.jobConfiguration.query.query as query_text
    #   FROM `${var.project_id}.${google_bigquery_dataset.logs.dataset_id}.cloudaudit_googleapis_com_data_access_*`
    #   WHERE protopayload_auditlog.serviceName = 'bigquery.googleapis.com'
        # AND protopayload_auditlog.methodName = 'jobservice.jobcompleted'
        # AND protopayload_auditlog.servicedata_v1_bigquery.jobCompletedEvent.eventName = 'query_job_completed'
    #   ORDER BY date DESC, estimated_cost_usd DESC
    # EOT
    # use_legacy_sql = false
#   }
  
#   depends_on = [google_logging_project_sink.bigquery_logs]
# }
