
resource "datadog_monitor" "apm_error_rate" {
  name               = "${var.service_name}-tasa-errores-${var.environment}"
  type               = "query alert"
  message            = <<EOT
La aplicación ${var.service_name} está experimentando una alta tasa de errores.

Notificación a: ${var.team_email}
EOT
  escalation_message = "La tasa de errores sigue siendo alta. Por favor, revisar urgentemente. ${var.team_email}"

  query = "sum(last_5m):100 * sum:trace.flask.request.errors{env:${var.environment},service:${var.service_name}}.as_count() / sum:trace.flask.request.hits{env:${var.environment},service:${var.service_name}}.as_count() > 5"

  monitor_thresholds {
    critical = 5
    warning  = 2
  }

  notify_no_data    = false
  renotify_interval = 60

  include_tags = true

  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "managed-by:terraform",
    "type:apm"
  ]
}


resource "datadog_monitor" "request_count" {
  name               = "${var.service_name}-contador-peticiones-${var.environment}"
  type               = "query alert"
  message            = <<EOT
No se están recibiendo peticiones en ${var.service_name}.

Notificación a: ${var.team_email}
EOT
  escalation_message = "Todavía no se reciben peticiones. Por favor, verificar si la aplicación está funcionando. ${var.team_email}"

  query = "sum(last_5m):sum:trace.flask.request.hits{env:${var.environment},service:${var.service_name}}.as_count() + sum:trace.express.request.hits{env:${var.environment},service:${var.service_name}}.as_count() < 1"

  monitor_thresholds {
    critical = 1
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 30

  include_tags = true

  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "managed-by:terraform",
    "type:apm"
  ]
}

resource "datadog_monitor" "not_found_count" {
  name               = "${var.service_name}-contador-404-${var.environment}"
  type               = "query alert"
  message            = <<EOT
El número de respuestas 404 en ${var.service_name} es demasiado alto.

Notificación a: ${var.team_email}
EOT
  escalation_message = "El número de respuestas 404 sigue siendo alto. ${var.team_email}"

  query = "sum(last_5m):sum:trace.flask.request.hits{env:${var.environment},service:${var.service_name},http.status_code:404}.as_count() + sum:trace.express.request.hits{env:${var.environment},service:${var.service_name},http.status_code:404}.as_count() > 10"

  monitor_thresholds {
    critical = 10
    warning  = 5
  }

  notify_no_data    = false
  renotify_interval = 60

  include_tags = true

  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "endpoint:not-found",
    "managed-by:terraform",
    "type:apm"
  ]
}