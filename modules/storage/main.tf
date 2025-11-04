# Cloud Storage Module - Enterprise GCS Buckets with CMEK

# Raw Data Bucket - Landing zone for data ingestion
resource "google_storage_bucket" "raw_data" {
  name          = "${var.project_id}-raw-data-${var.environment}"
  location      = var.region
  project       = var.project_id
  storage_class = "STANDARD"
  
  # Enable uniform bucket-level access (recommended)
  uniform_bucket_level_access = true
  
  # Public access prevention (security best practice)
  public_access_prevention = "enforced"
  
  # Versioning to prevent accidental deletion
  versioning {
    enabled = true
  }
  
  # CMEK encryption
  encryption {
    default_kms_key_name = var.kms_key_id
  }
  
  # Lifecycle rule: Move to Nearline after 30 days
  lifecycle_rule {
    condition {
      age = 30
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  
  # Lifecycle rule: Move to Coldline after 90 days
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type          = "SetStorageClass"
      storage_class = "COLDLINE"
    }
  }
  
  labels = merge(
    var.labels,
    {
      bucket_type = "raw-data"
      data_zone   = "landing"
    }
  )
  
  # Prevent accidental deletion in production
  force_destroy = var.force_destroy
  
  depends_on = [var.kms_key_id]
}

# Processed Data Bucket - Curated/transformed data
resource "google_storage_bucket" "processed_data" {
  name          = "${var.project_id}-processed-data-${var.environment}"
  location      = var.region
  project       = var.project_id
  storage_class = "STANDARD"
  
  uniform_bucket_level_access = true
  
  public_access_prevention = "enforced"
  
  versioning {
    enabled = true
  }
  
  encryption {
    default_kms_key_name = var.kms_key_id
  }
  
  # Keep in Standard storage longer (frequently accessed)
  lifecycle_rule {
    condition {
      age = 60
    }
    action {
      type          = "SetStorageClass"
      storage_class = "NEARLINE"
    }
  }
  
  labels = merge(
    var.labels,
    {
      bucket_type = "processed-data"
      data_zone   = "curated"
    }
  )
  
  force_destroy = var.force_destroy
  
  depends_on = [var.kms_key_id]
}

# Archive Bucket - Long-term historical data
resource "google_storage_bucket" "archive" {
  name          = "${var.project_id}-archive-${var.environment}"
  location      = var.region
  project       = var.project_id
  storage_class = "ARCHIVE"  # Cheapest storage for rarely accessed data
  
  uniform_bucket_level_access = true
  
  public_access_prevention = "enforced"
  
  versioning {
    enabled = true
  }
  
  encryption {
    default_kms_key_name = var.kms_key_id
  }
  
  labels = merge(
    var.labels,
    {
      bucket_type = "archive"
      data_zone   = "historical"
    }
  )
  
  force_destroy = var.force_destroy
  
  depends_on = [var.kms_key_id]
}

# Logs Bucket - Application and system logs
resource "google_storage_bucket" "logs" {
  name          = "${var.project_id}-logs-${var.environment}"
  location      = var.region
  project       = var.project_id
  storage_class = "STANDARD"
  
  uniform_bucket_level_access = true
  
  public_access_prevention = "enforced"
  
  versioning {
    enabled = false  # Logs don't need versioning
  }
  
  encryption {
    default_kms_key_name = var.kms_key_id
  }
  
  # Delete logs after 90 days (compliance retention)
  lifecycle_rule {
    condition {
      age = 90
    }
    action {
      type = "Delete"
    }
  }
  
  labels = merge(
    var.labels,
    {
      bucket_type = "logs"
      data_zone   = "operational"
    }
  )
  
  force_destroy = true  # Allow deletion of logs
  
  depends_on = [var.kms_key_id]
}

# Grant Storage service account access to KMS key
