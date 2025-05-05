import {
	to = module.monitor_1.datadog_monitor.already_monitor
	id = "1"
}

module "monitor_1" {
	source = "./monitors/1_monitor"
	providers = {
		datadog = datadog
	}
	monitor_params = var.monitor_params[0]
}