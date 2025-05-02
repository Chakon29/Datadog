variable "datadog_api_key" {
  description = "API Key de Datadog"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Application Key de Datadog"
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "URL de la API de Datadog"
  type        = string
  default     = "https://api.us5.datadoghq.com/"
}

variable "environment" {
  description = "Entorno de despliegue (dev, prod)"
  type        = string
  default     = "dev"
}

variable "monitor_ids" {
  description = "Lista de IDs de monitores a importar"
  type        = list(string)
  default     = []
}

variable "dashboard_ids" {
  description = "Lista de IDs de dashboards a importar"
  type        = list(string)
  default     = []
}

variable "dashboard_names" {
  description = "Lista de nombres de archivos JSON de dashboards"
  type        = list(string)
  default     = []
}