variable "monitor_params" {
	type = object({
		monitor_id = string
		name_cm = string
		monitor_type = string
		monitor_msg = string
		monitor_query = string
		critical_value = number
		warning_value = number
		criticalr_value = number
		trigg_w = string
		rec_w = string
		renotify_interval = number
		new_group_delay = number
		monitor_tags = list(string)
		no_data_fr = number
		monitor_renotify_s = list(string)
		monitor_renotify_o = number
		monitor_notify_nodata = bool
		monitor_timeout_h = number
		monitor_on_missing_data = string
		monitor_enable_logs_sample = bool
		groupby_simple_monitor = bool
		monitor_path = string

	})
}