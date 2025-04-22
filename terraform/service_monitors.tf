# Monitor de disponibilidad del servicio
resource "datadog_monitor" "respuesta_moderada" {
  name               = "${var.service_name}-tiempo-respuesta-moderado-${var.environment}"
  type               = "metric alert"
  message            = <<EOT
El sitio de prueba con retardo de 2 segundos está respondiendo más lento de lo esperado.
Este monitor está diseñado para activarse cuando el tiempo de respuesta supera los 2.5 segundos.
Notificación a: @${var.team_email}
EOT
  escalation_message = "El tiempo de respuesta sigue siendo elevado en la prueba de retardo de 2 segundos. @${var.team_email}"

  # Consulta corregida - La anterior tenía una sintaxis de tag inválida
  query = "avg(last_5m):avg:http.response_time{test_endpoint:delay_2s} > 2500"

  monitor_thresholds {
    critical = 2500
    warning  = 2200
  }

  notify_no_data    = true
  renotify_interval = 60

  tags = [
    "prueba:retardo-moderado",
    "env:${var.environment}",
    "managed-by:terraform"
  ]
}
# Monitor de tiempo de respuesta
resource "datadog_monitor" "response_time" {
  name               = "${var.service_name}-tiempo-respuesta-${var.environment}"
  type               = "metric alert"
  message            = <<EOT
El tiempo de respuesta del servicio ${var.service_name} es superior a ${var.response_time_threshold}ms.
Esto puede afectar la experiencia de usuario.

Notificación a: @${var.team_email}
EOT
  escalation_message = "El tiempo de respuesta sigue siendo elevado. Por favor, revisar urgentemente. @${var.team_email}"

  query = "avg(last_5m):avg:http.response_time{service:${var.service_name},env:${var.environment}} > ${var.response_time_threshold}"

  monitor_thresholds {
    critical = var.response_time_threshold
    warning  = var.response_time_threshold * 0.8
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60

  include_tags = true
  
  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "managed-by:terraform"
  ]
}