terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.20.0"
    }
  }
}

provider "datadog" {
  api_key = var.datadog_api_key
  app_key = var.datadog_app_key
  api_url = var.datadog_api_url
}

# Módulos para importación de monitores
module "imported_monitors" {
  source = "./monitors/imported_monitors"
  count  = length(var.monitor_ids)
  
  monitor_id     = var.monitor_ids[count.index]
  monitor_params = var.monitor_params[count.index]
}

# Módulos para importación de dashboards
module "imported_dashboards" {
  source = "./dashboards/imported_dashboards"
  count  = length(var.dashboard_ids)
  
  dashboard_id = var.dashboard_ids[count.index]
  dashboard    = file("./dashboards/imported_dashboards/${var.dashboard_names[count.index]}.json")
}