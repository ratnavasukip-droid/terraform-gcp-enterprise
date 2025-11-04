output "notification_channel_id" {
  description = "Notification channel resource id"
  value       = google_monitoring_notification_channel.email_ops.id
}

output "alert_policy_id" {
  description = "Alert policy resource id"
  value       = google_monitoring_alert_policy.gke_high_cpu.id
}

// dashboard output removed because dashboard creation has been deferred

output "dashboard_id" {
  description = "Dashboard resource id"
  value       = google_monitoring_dashboard.gke_overview.id
}
