# Cloud KMS Module - Customer-Managed Encryption Keys (CMEK)

# Create a Key Ring (container for keys)
# Key rings are regional and cannot be deleted
resource "google_kms_key_ring" "key_ring" {
  name     = var.key_ring_name
  location = var.region
  project  = var.project_id
}

# Create a crypto key for Cloud Storage buckets
# This key will encrypt data in GCS buckets
resource "google_kms_crypto_key" "storage_key" {
  name     = var.storage_key_name
  key_ring = google_kms_key_ring.key_ring.id
  
  # Rotation period (90 days recommended for compliance)
  rotation_period = var.rotation_period
  
  # Purpose: Encrypt/Decrypt data
  purpose = "ENCRYPT_DECRYPT"
  
  # Prevent accidental deletion (comment out for dev/testing)
  lifecycle {
    prevent_destroy = false  # Set to true in production
  }
  
  # Key version template
  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = var.protection_level
  }
  
  labels = var.labels
}

# Create a crypto key for BigQuery datasets (we'll use later)
resource "google_kms_crypto_key" "bigquery_key" {
  name     = var.bigquery_key_name
  key_ring = google_kms_key_ring.key_ring.id
  
  rotation_period = var.rotation_period
  purpose         = "ENCRYPT_DECRYPT"
  
  lifecycle {
    prevent_destroy = false
  }
  
  version_template {
    algorithm        = "GOOGLE_SYMMETRIC_ENCRYPTION"
    protection_level = var.protection_level
  }
  
  labels = var.labels
}

# Grant Cloud Storage service account permission to use the key
# This allows GCS to encrypt/decrypt data automatically