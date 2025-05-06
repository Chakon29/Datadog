import {
  to = module.monitor_1.datadog_monitor.vm_gcp_monitor
  id = "4227317"
}

module "monitor_1" {
  source = "./monitors/1_monitor"
  providers = {
    datadog = datadog
  }
  monitor_params = var.monitor_parametros[0]
}


import {
   to = module.monitor_2.datadog_monitor.vm_gcp_monitor
   id = "4227286"
 }
 
 module "monitor_2" {
   source = "./monitors/2_monitor"
   providers = {
     datadog = datadog
   }
   monitor_params = var.monitor_parametros[1]
 }