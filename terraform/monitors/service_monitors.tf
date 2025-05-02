resource "datadog_monitor" "already_monitor_simple" {
  name               = var.monitor_params.name_cm
  type               = var.monitor_params.monitor_type
  message            = var.monitor_params.monitor_msg
  query              = var.monitor_params.monitor_query
  include_tags       = var.monitor_params.include_tags
  notify_no_data     = var.monitor_params.monitor_notify_nodata
  new_group_delay    = var.monitor_params.new_group_delay
  renotify_interval  = var.monitor_params.renotify_interval
  renotify_statuses  = var.monitor_params.monitor_renotify_s
  
  monitor_thresholds {
    critical          = var.monitor_params.critical_value
    warning           = var.monitor_params.warning_value
    critical_recovery = var.monitor_params.criticalr_value
  }
  
  tags = var.monitor_params.monitor_tags
}