# --- Service Account & IAM ---
resource "google_service_account" "composer_sa" {
  account_id   = "composer-env-sa"
  display_name = "Cloud Composer Environment Service Account"
  project      = var.project_id
}

# Grant the Composer service account the required roles
resource "google_project_iam_member" "composer_worker_role" {
  project = var.project_id
  role    = "roles/composer.worker"
  member  = "serviceAccount:${google_service_account.composer_sa.email}"
}

# --- Permissions for our Service Account ---
resource "google_project_iam_member" "storage_admin_role" {
  project = var.project_id
  role    = "roles/storage.admin"
  member  = "serviceAccount:${google_service_account.composer_sa.email}"
}

resource "google_project_iam_member" "bigquery_user_role" {
  project = var.project_id
  role    = "roles/bigquery.user"
  member  = "serviceAccount:${google_service_account.composer_sa.email}"
}

resource "google_kms_crypto_key_iam_member" "kms_encrypter_decrypter_role" {
  crypto_key_id = var.bigquery_kms_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.composer_sa.email}"
}

resource "google_kms_crypto_key_iam_member" "kms_encrypter_decrypter_role_storage" {
  crypto_key_id = var.storage_kms_key_id
  role          = "roles/cloudkms.cryptoKeyEncrypterDecrypter"
  member        = "serviceAccount:${google_service_account.composer_sa.email}"
}

# This resource creates the Cloud Composer environment
resource "google_composer_environment" "composer" {
  name    = "${var.project_id}-composer-env"
  project = var.project_id
  region  = var.region

  config {
    environment_size = var.environment_size
    software_config {
      image_version = var.airflow_image_version
    }

    node_config {
      network         = var.vpc_self_link
      subnetwork      = var.composer_subnet_self_link
      service_account = google_service_account.composer_sa.email
    }
  }

  depends_on = [
    google_project_iam_member.composer_worker_role,
    google_project_iam_member.storage_admin_role,
    google_project_iam_member.bigquery_user_role,
    google_kms_crypto_key_iam_member.kms_encrypter_decrypter_role,
    google_kms_crypto_key_iam_member.kms_encrypter_decrypter_role_storage
  ]
}

# Output values
output "composer_airflow_uri" {
  value     = google_composer_environment.composer.config[0].airflow_uri
  sensitive = true
}

output "composer_dags_bucket" {
  value = google_composer_environment.composer.config[0].dag_gcs_prefix
}