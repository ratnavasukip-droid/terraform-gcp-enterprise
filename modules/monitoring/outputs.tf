output "notification_channel_id" {
  description = "Notification channel resource name"
  value       = google_monitoring_notification_channel.email_ops.name
}

output "alert_policy_name" {
  description = "Alert policy resource name"
  value       = google_monitoring_alert_policy.gke_high_cpu.name
}

output "dashboard_name" {
  description = "Dashboard resource name"
  value       = google_monitoring_dashboard.gke_overview.name
}
