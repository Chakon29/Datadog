variable "monitor_params" {
  type = list(object({
    monitor_id = optional(string)
    name_cm = optional(string)
    monitor_type = optional(string)
    monitor_msg = optional(string)
    monitor_query = optional(string)
    critical_value = optional(number)
    warning_value = optional(number)
    criticalr_value = optional(number)
    renotify_interval = optional(number)
    new_group_delay = optional(number)
    monitor_tags = optional(list(string))
    no_data_fr = optional(number)
    include_tags = optional(bool)
    monitor_renotify_s = optional(list(string))
    monitor_notify_nodata = optional(bool)
  }))
  default = []
}