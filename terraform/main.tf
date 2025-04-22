terraform {
  required_providers {
    datadog = {
      source  = "DataDog/datadog"
      version = "~> 3.20.0"
    }
  }
  
  # Opcional: Configuración del backend para almacenar el estado
  # Puedes usar un backend local para comenzar
}

# Configuración del proveedor con autenticación
provider "datadog" {
  api_key = var.datadog_api_key  # API Key generada para la cuenta de servicio
  app_key = var.datadog_app_key  # Application Key generada para la cuenta de servicio
  api_url = var.datadog_api_url  # URL de la API (por defecto: https://api.datadoghq.com/)
}