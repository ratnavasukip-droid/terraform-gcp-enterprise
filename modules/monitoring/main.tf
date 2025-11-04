// Enable Monitoring APIs needed for dashboards and alerting
resource "google_project_service" "monitoring_api" {
  project = var.project_id
  service = "monitoring.googleapis.com"
  disable_on_destroy = false
}

// Notification channel (email)
resource "google_monitoring_notification_channel" "email_ops" {
  project = var.project_id
  display_name = "Ops Email"
  type = "email"
  labels = {
    email_address = var.notification_email
  }

  depends_on = [google_project_service.monitoring_api]
}

// Alert policy: GKE cluster node CPU utilization > 80% for 5 minutes
resource "google_monitoring_alert_policy" "gke_high_cpu" {
  project = var.project_id
  display_name = "GKE: High node CPU (>80%)"
  combiner = "OR"

  notification_channels = [google_monitoring_notification_channel.email_ops.name]

  conditions {
    display_name = "Node CPU utilization > 80%"
    condition_threshold {
      # Use compute instance CPU utilization metric which is commonly available for GKE node VMs
      filter = "metric.type=\"compute.googleapis.com/instance/cpu/utilization\" resource.type=\"gce_instance\""
      aggregations {
        alignment_period     = "60s"
        per_series_aligner   = "ALIGN_MEAN"
      }
      comparison = "COMPARISON_GT"
      threshold_value = 0.8
      duration = "300s"
    }
  }

  depends_on = [google_project_service.monitoring_api]
}

// Simple dashboard with a single chart for node CPU utilization for the cluster
// Dashboard creation removed for now because enabling the Dashboard API requires
// additional permissions in some projects. We keep alerting and notification channel.
