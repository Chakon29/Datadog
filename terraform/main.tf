import {
  to = module.monitor_1.datadog_monitor.VM_GCP_Uso_de_disco_Critical
  id = "1"
}
module "monitor_1" {
	source = "./monitors/1_monitor"
	providers = {
		datadog = datadog
	}
	monitor_params = var.monitor_parametros[0]  # Note the [0] index here
}