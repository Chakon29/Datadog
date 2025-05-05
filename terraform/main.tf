import {
  to = module.monitor_1.datadog_monitor.VM_GCP_Uso_de_disco_Critical_111
  id = "3616409"
}

module "monitor_1" {
  source = "./monitors/1_monitor"
  providers = {
    datadog = datadog
  }
  monitor_params = var.monitor_parametros[0]
}


 import {
   to = module.monitor_1.datadog_monitor.VM_GCP_Uso_de_disco_Critical
   id = "36164091"
 }
 
 module "monitor_2" {
   source = "./monitors/2_monitor"
   providers = {
     datadog = datadog
   }
   monitor_params = var.monitor_parametros[1]
 }