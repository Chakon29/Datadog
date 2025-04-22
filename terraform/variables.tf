variable "datadog_api_key" {
  description = "API Key de Datadog asociada a la cuenta de servicio"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Application Key de Datadog asociada a la cuenta de servicio"
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "URL de la API de Datadog (EU o US)"
  type        = string
  default     = "https://api.datadoghq.com/"
}

variable "environment" {
  description = "Entorno de despliegue (dev, test, prod)"
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "Nombre del servicio que está siendo monitoreado"
  type        = string
  default     = "mi-aplicacion"
}

variable "team_email" {
  description = "Email del equipo para notificaciones"
  type        = string
  default     = "equipo@miempresa.com"
}