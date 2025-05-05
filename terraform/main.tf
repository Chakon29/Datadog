import {
	to = module.monitor_1.datadog_monitor.already_monitor
	id = "1"
}

module "simple_monitor_148065962" {
	source = "./monitors/1_monitor"
	providers = {
		datadog = datadog
	}
	monitor_params = var.monitor_params[0]
}