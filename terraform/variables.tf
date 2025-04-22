variable "datadog_api_key" {
  description = "API Key"
  type        = string
  sensitive   = true
}

variable "datadog_app_key" {
  description = "Application Key"
  type        = string
  sensitive   = true
}

variable "datadog_api_url" {
  description = "URL de la API de Datadog (EU o US)"
  type        = string
  default     = "https://api.us5.datadoghq.com/"
}

variable "environment" {
  description = "Entorno de despliegue"
  type        = string
  default     = "dev"
}

variable "service_name" {
  description = "Nombre del servicio"
  type        = string
  default     = "mi-aplicacion"
}

variable "team_email" {
  description = "Email para notificaciones"
  type        = string
  default     = "vicente.chacon@innfinit.com"
}

variable "response_time_threshold" {
  description = "Umbral de tiempo de respuesta en milisegundos para alertas"
  type        = number
  default     = 500
}