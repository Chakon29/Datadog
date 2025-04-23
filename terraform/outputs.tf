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

# Monitores de pruebas de disponibilidad
output "sitio_siempre_disponible_test_id" {
  description = "ID del test sintético para el sitio siempre disponible (200)"
  value       = datadog_synthetics_test.sitio_siempre_disponible.id
}

output "sitio_siempre_disponible_monitor_id" {
  description = "ID del monitor asociado al test del sitio siempre disponible (200)"
  value       = datadog_synthetics_test.sitio_siempre_disponible.monitor_id
}

output "sitio_siempre_disponible_url" {
  description = "URL del test sintético para el sitio siempre disponible (200)"
  value       = "https://app.datadoghq.com/synthetics/details/${datadog_synthetics_test.sitio_siempre_disponible.id}"
}

output "sitio_siempre_indisponible_test_id" {
  description = "ID del test sintético para el sitio siempre indisponible (503)"
  value       = datadog_synthetics_test.sitio_siempre_indisponible.id
}

output "sitio_siempre_indisponible_monitor_id" {
  description = "ID del monitor asociado al test del sitio siempre indisponible (503)"
  value       = datadog_synthetics_test.sitio_siempre_indisponible.monitor_id
}

output "sitio_siempre_indisponible_url" {
  description = "URL del test sintético para el sitio siempre indisponible (503)"
  value       = "https://app.datadoghq.com/synthetics/details/${datadog_synthetics_test.sitio_siempre_indisponible.id}"
}

output "sitio_not_found_test_id" {
  description = "ID del test sintético para el sitio con error 404"
  value       = datadog_synthetics_test.sitio_not_found.id
}

output "sitio_not_found_monitor_id" {
  description = "ID del monitor asociado al test del sitio con error 404"
  value       = datadog_synthetics_test.sitio_not_found.monitor_id
}

output "sitio_not_found_url" {
  description = "URL del test sintético para el sitio con error 404"
  value       = "https://app.datadoghq.com/synthetics/details/${datadog_synthetics_test.sitio_not_found.id}"
}

# Monitores de pruebas de tiempo de respuesta
output "retardo_alto_test_id" {
  description = "ID del test sintético para el sitio con retardo alto (5s)"
  value       = datadog_synthetics_test.retardo_alto.id
}

output "retardo_alto_monitor_id" {
  description = "ID del monitor asociado al test del sitio con retardo alto (5s)"
  value       = datadog_synthetics_test.retardo_alto.monitor_id
}

output "retardo_alto_url" {
  description = "URL del test sintético para el sitio con retardo alto (5s)"
  value       = "https://app.datadoghq.com/synthetics/details/${datadog_synthetics_test.retardo_alto.id}"
}

output "service_overview_dashboard_id" {
  description = "ID del dashboard principal del servicio"
  value       = datadog_dashboard.service_overview.id
}

output "service_overview_dashboard_url" {
  description = "URL del dashboard principal del servicio"
  value       = "https://app.datadoghq.com/dashboard/${datadog_dashboard.service_overview.id}"
}

output "service_slo_dashboard_id" {
  description = "ID del dashboard de SLO del servicio"
  value       = datadog_dashboard.service_slo.id
}

output "service_slo_dashboard_url" {
  description = "URL del dashboard de SLO del servicio"
  value       = "https://app.datadoghq.com/dashboard/${datadog_dashboard.service_slo.id}"
}

output "response_time_dashboard_id" {
  description = "ID del dashboard detallado de tiempos de respuesta"
  value       = datadog_dashboard.response_time_detail.id
}

output "response_time_dashboard_url" {
  description = "URL del dashboard detallado de tiempos de respuesta"
  value       = "https://app.datadoghq.com/dashboard/${datadog_dashboard.response_time_detail.id}"
}