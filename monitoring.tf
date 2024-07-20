resource "google_monitoring_alert_policy" "uptime_check" {
  display_name = "Uptime Check"
  combiner     = "OR"

  conditions {
    display_name = "Uptime Check Condition"
    condition_threshold {
      filter = "metric.type=\"monitoring.googleapis.com/uptime_check/check_passed\" AND resource.type=\"uptime_check_config\""
      comparison = "COMPARISON_GT"
      duration = "60s"
      aggregations {
        alignment_period = "60s"
        per_series_aligner = "ALIGN_RATE"
      }
      threshold_value = 1
    }
  }

  notification_channels = [
    google_monitoring_notification_channel.email.id,
  ]
}

resource "google_monitoring_notification_channel" "email" {
  display_name = "Email Notifications"
  type         = "email"

  labels = {
    email_address = "your-email@example.com"
  }
}
