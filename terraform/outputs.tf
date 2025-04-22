output "service_availability_monitor_id" {
  description = "ID del monitor de disponibilidad del servicio"
  value       = datadog_monitor.service_availability.id
}

output "service_availability_monitor_url" {
  description = "URL del monitor de disponibilidad del servicio"
  value       = "https://app.datadoghq.com/monitors/${datadog_monitor.service_availability.id}"
}

output "response_time_monitor_id" {
  description = "ID del monitor de tiempo de respuesta"
  value       = datadog_monitor.response_time.id
}

output "response_time_monitor_url" {
  description = "URL del monitor de tiempo de respuesta"
  value       = "https://app.datadoghq.com/monitors/${datadog_monitor.response_time.id}"
}