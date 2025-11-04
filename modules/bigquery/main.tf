# BigQuery Module - Data Warehouse Datasets

# Raw Dataset - Mirrors raw data from GCS
resource "google_bigquery_dataset" "raw_data" {
  dataset_id  = "${var.dataset_prefix}_raw_data_${var.environment}"
  project     = var.project_id
  location    = var.region
  description = "Raw data loaded from Cloud Storage - minimal transformations"
  
  # CMEK encryption with BigQuery key
  default_encryption_configuration {
    kms_key_name = var.kms_key_id
  }
  
  # Default table expiration (90 days for raw data in dev)
  default_table_expiration_ms = var.default_table_expiration_ms
  
  # Deletion protection (prevent accidental deletion)
  delete_contents_on_destroy = var.delete_contents_on_destroy
  
  # Labels for organization
  labels = merge(
    var.labels,
    {
      dataset_type = "raw"
      data_zone    = "landing"
    }
  )
  
  # Access control (we'll add IAM bindings separately)
  # Empty access block means we use IAM (recommended)
  access {
    role          = "OWNER"
    user_by_email = var.owner_email
  }
}

# Analytics Dataset - Cleaned, business-ready data
resource "google_bigquery_dataset" "analytics" {
  dataset_id  = "${var.dataset_prefix}_analytics_${var.environment}"
  project     = var.project_id
  location    = var.region
  description = "Curated analytics data - cleaned and transformed for reporting"
  
  default_encryption_configuration {
    kms_key_name = var.kms_key_id
  }
  
  # Longer expiration for analytics (365 days)
  default_table_expiration_ms = var.default_table_expiration_ms * 4
  
  delete_contents_on_destroy = var.delete_contents_on_destroy
  
  labels = merge(
    var.labels,
    {
      dataset_type = "analytics"
      data_zone    = "curated"
    }
  )
  
  access {
    role          = "OWNER"
    user_by_email = var.owner_email
  }
}

# ML Dataset - Machine learning features and training data
resource "google_bigquery_dataset" "ml_features" {
  dataset_id  = "${var.dataset_prefix}_ml_features_${var.environment}"
  project     = var.project_id
  location    = var.region
  description = "Machine learning features and training datasets"
  
  default_encryption_configuration {
    kms_key_name = var.kms_key_id
  }
  
  # No expiration for ML datasets (keep training data)
  default_table_expiration_ms = null
  
  delete_contents_on_destroy = var.delete_contents_on_destroy
  
  labels = merge(
    var.labels,
    {
      dataset_type = "ml"
      data_zone    = "ml-training"
    }
  )
  
  access {
    role          = "OWNER"
    user_by_email = var.owner_email
  }
}


# IAM bindings for datasets (simulating AD groups)
# In real scenario, these would be actual AD groups synced to Cloud Identity

# Data Engineers - Full access to raw dataset
resource "google_bigquery_dataset_iam_member" "raw_data_editors" {
  dataset_id = google_bigquery_dataset.raw_data.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = var.data_engineers_group
  project    = var.project_id
}

# Data Analysts - Read access to analytics dataset
resource "google_bigquery_dataset_iam_member" "analytics_viewers" {
  dataset_id = google_bigquery_dataset.analytics.dataset_id
  role       = "roles/bigquery.dataViewer"
  member     = var.data_analysts_group
  project    = var.project_id
}

# Data Scientists - Full access to ML dataset
resource "google_bigquery_dataset_iam_member" "ml_editors" {
  dataset_id = google_bigquery_dataset.ml_features.dataset_id
  role       = "roles/bigquery.dataEditor"
  member     = var.data_scientists_group
  project    = var.project_id
}
