# Monitor de disponibilidad del servicio
resource "datadog_monitor" "service_availability" {
  name               = "${var.service_name}-disponibilidad-${var.environment}"
  type               = "service check"
  message            = <<EOT
El servicio ${var.service_name} parece estar caído o inaccesible.
Favor de revisar la infraestructura y los logs para identificar el problema.

Notificación a: @${var.team_email}
EOT
  escalation_message = "El servicio ${var.service_name} sigue sin responder. Se requiere atención urgente. @${var.team_email}"

  query = "\"http.can_connect\".over(\"instance:${var.service_name}_status_check\").by(\"host\",\"url\").last(5).count_by_status()"

  monitor_thresholds {
    critical = 3
    warning  = 2
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30

  include_tags = true
  
  tags = [
    "service:${var.service_name}",
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