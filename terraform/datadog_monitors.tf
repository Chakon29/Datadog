resource "datadog_monitor" "service_availability" {
  name               = "${var.service_name}-availability-${var.environment}"
  type               = "metric alert"
  message            = <<EOT
El servicio ${var.service_name} está experimentando problemas de disponibilidad en ${var.environment}.
Por favor, revisa el servicio.
Notificación a: @${var.team_email}
EOT
  escalation_message = "El problema de disponibilidad persiste, por favor atender urgentemente! @${var.team_email}"

  query = "avg(last_5m):avg:http.can_connect{service:${var.service_name},env:${var.environment}} < 1"

  monitor_thresholds {
    critical = 1
    warning  = null
  }

  notify_no_data    = true
  renotify_interval = 30

  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "managed-by:terraform"
  ]
}

resource "datadog_monitor" "response_time" {
  name               = "${var.service_name}-response-time-${var.environment}"
  type               = "metric alert"
  message            = <<EOT
El tiempo de respuesta de ${var.service_name} está por encima del umbral (${var.response_time_threshold}ms) en ${var.environment}.
Por favor, investigar el rendimiento del servicio.
Notificación a: @${var.team_email}
EOT
  escalation_message = "El tiempo de respuesta sigue siendo elevado! @${var.team_email}"

  query = "avg(last_5m):avg:http.response_time{service:${var.service_name},env:${var.environment}} > ${var.response_time_threshold}"

  monitor_thresholds {
    critical = var.response_time_threshold
    warning  = var.response_time_threshold * 0.8
  }

  notify_no_data    = false
  renotify_interval = 60

  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "managed-by:terraform"
  ]
}

resource "datadog_synthetics_test" "foo" {
  name    = "${var.service_name}-synthetic-test-${var.environment}"
  type    = "api"
  subtype = "http"
  
  request_definition {
    method = "GET"
    url    = "https://example.com"
  }
  
  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }
  
  locations = ["aws:eu-central-1"]
  status    = "live"
  
  message = "Synthetic test for ${var.service_name} in ${var.environment}"
  tags    = ["service:${var.service_name}", "env:${var.environment}", "managed-by:terraform"]
  
  options_list {
    tick_every = 900
    
    retry {
      count    = 2
      interval = 300
    }
    
    monitor_options {
      renotify_interval = 120
    }
  }
}

resource "datadog_monitor" "foo" {
  name    = "${var.service_name}-simple-alert-${var.environment}"
  type    = "metric alert"
  message = "Se ha detectado un problema en el servicio ${var.service_name} en ${var.environment}. @${var.team_email}"
  
  query = "avg(last_5m):sum:system.cpu.system{service:${var.service_name},env:${var.environment}} by {host} > 75"
  
  monitor_thresholds {
    critical = 75
    warning  = 70
  }
  
  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "managed-by:terraform"
  ]
}

resource "datadog_monitor" "bar" {
  name    = "${var.service_name}-composite-monitor-${var.environment}"
  type    = "composite"
  message = "Monitor compuesto activado para ${var.service_name} en ${var.environment}. @${var.team_email}"
  query   = "${datadog_monitor.foo.id} || ${datadog_synthetics_test.foo.monitor_id}"
  
  tags = [
    "service:${var.service_name}",
    "env:${var.environment}",
    "managed-by:terraform"
  ]
}