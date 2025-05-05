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
