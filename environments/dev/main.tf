# Terraform configuration block
terraform {
  required_version = ">= 1.5.0"
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "~> 5.0"
    }
    random = {
      source  = "hashicorp/random"
      version = "~> 3.5"
    }
    time = {
      source  = "hashicorp/time"
      version = "~> 0.9.0"
    }
  }
}


# Configure the Google Cloud Provider
provider "google" {
  # Authentication handled by gcloud CLI
  # Region where resources will be created (if not specified per-resource)
  region  = var.region
  # Default zone within the region
  zone    = var.zone
}

# Call the project module to create the project
module "project" {
  source = "../../modules/project"
  
  # Pass variables to the module
  project_name    = var.project_name
  project_id      = var.project_id_base
  billing_account = var.billing_account
  environment     = "dev"
  team            = "data-engineering"
}
# ... (keep existing project module code)

# Create KMS encryption keys
module "kms" {
  source = "../../modules/kms"
  
  project_id     = module.project.project_id
  project_number = module.project.project_number
  region         = var.region
  
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
  
  # Wait for project to be fully created
  depends_on = [module.project]
}
# ... (keep existing project and kms modules)

# Create Cloud Storage buckets with CMEK encryption
module "storage" {
  source = "../../modules/storage"
  
  project_id     = module.project.project_id
  project_number = module.project.project_number
  region         = var.region
  environment    = "dev"
  kms_key_id     = module.kms.storage_key_id
  force_destroy  = true  # Allow deletion in dev
  
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
  
  depends_on = [module.kms]
}


# ... (keep existing project, kms, and storage modules)

# Create BigQuery datasets with CMEK encryption
module "bigquery" {
  source = "../../modules/bigquery"
  
  project_id     = module.project.project_id
  project_number = module.project.project_number
  region         = var.region
  environment    = "dev"
  kms_key_id     = module.kms.bigquery_key_id
  
  # Use your actual email (dataset owner)
  owner_email = var.owner_email
  
  # IAM members (simulating AD groups with your email for now)
  data_engineers_group  = "user:${var.owner_email}"
  data_analysts_group   = "user:${var.owner_email}"
  data_scientists_group = "user:${var.owner_email}"
  
  # Dev settings
  delete_contents_on_destroy  = true   # Easy cleanup in dev
  default_table_expiration_ms = 7776000000  # 90 days
  
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
  
  depends_on = [module.kms, module.storage]
}


# ... (keep existing modules)

# Create centralized logging
module "logging" {
  source = "../../modules/logging"
  
  project_id = module.project.project_id
  region     = var.region
  environment = "dev"
  kms_key_id = module.kms.bigquery_key_id
  
  labels = {
    environment = "dev"
    managed_by  = "terraform"
  }
  
  depends_on = [module.kms, module.bigquery]
}

# ... (project, kms, storage, bigquery modules)

# Create the private network (VPC)
module "networking" {
  source = "../../modules/networking"

  project_id = module.project.project_id
  region     = var.region

  # We can use the default CIDR blocks from variables.tf
  # Or override them here if needed.

  depends_on = [module.project]
}

# ... (project, kms, storage, bigquery, networking modules)
# ... (project, kms, storage, bigquery, networking modules)

# Create the GKE (Kubernetes) cluster
module "gke" {
  source = "../../modules/gke"

  project_id         = module.project.project_id
  region             = var.region
  vpc_self_link      = module.networking.vpc_self_link
  gke_subnet_self_link = module.networking.gke_subnet_self_link

  depends_on = [module.networking]
}
# Monitoring: alerts and dashboards for cluster health
module "monitoring" {
  source = "../../modules/monitoring"

  project_id = module.project.project_id
  cluster_name = module.gke.cluster_name
  notification_email = var.owner_email

  depends_on = [module.gke]
}
# Create the Cloud Composer (Airflow) environment
module "composer" {
  source = "../../modules/composer"

  project_id                  = module.project.project_id
  project_number              = module.project.project_number
  region                      = var.region
  vpc_self_link               = module.networking.vpc_self_link
  composer_subnet_self_link   = module.networking.composer_subnet_self_link
  composer_subnet_cidr        = module.networking.composer_subnet_cidr
  bigquery_kms_key_id         = module.kms.bigquery_key_id
  storage_kms_key_id          = module.kms.storage_key_id

  # Make sure this version is correct (the one from before)
  airflow_image_version = "composer-3-airflow-3.1.0"
  environment_size      = "ENVIRONMENT_SIZE_SMALL"

  depends_on = [
    module.networking,
    module.bigquery,
    module.storage
  ]
}