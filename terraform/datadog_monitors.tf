# Monitor para verificar la disponibilidad de un servicio web
resource "datadog_monitor" "service_availability" {
  name               = "Disponibilidad del servicio ${var.service_name} en ${var.environment}"
  type               = "service check"
  message            = <<EOF
El servicio ${var.service_name} está experimentando problemas de disponibilidad en el entorno ${var.environment}.

Por favor, revise inmediatamente.
Notificaciones: @${var.team_email}
EOF
  escalation_message = "El servicio ${var.service_name} continúa caído. Escalando la alerta. @${var.team_email}"

  query = "\"http.can_connect\".over(\"service:${var.service_name}\",\"environment:${var.environment}\").by(\"host\",\"url\").last(5).count_by_status()"
  
  # La sintaxis correcta para service check es monitor_thresholds, no thresholds
  monitor_thresholds {
    critical = 5
    warning  = 3
    ok       = 1
  }

  notify_no_data    = true
  no_data_timeframe = 10
  renotify_interval = 60
  
  include_tags = true
  
  tags = [
    "env:${var.environment}",
    "service:${var.service_name}",
    "team:operations",
    "managed-by:terraform"
  ]
}

# Monitor para verificar altos tiempos de respuesta
resource "datadog_monitor" "response_time" {
  name               = "Tiempo de respuesta alto en ${var.service_name}"
  type               = "metric alert"
  message            = <<EOF
El tiempo de respuesta para ${var.service_name} está por encima del umbral de ${var.response_time_threshold}ms en el entorno ${var.environment}.

Posibles acciones:
1. Verificar carga del servidor
2. Revisar logs de la aplicación
3. Comprobar conexiones de base de datos

Notificaciones: @${var.team_email}
EOF

  query = "avg(last_5m):avg:http.response_time{service:${var.service_name},environment:${var.environment}} > ${var.response_time_threshold / 1000}"
  
  monitor_thresholds {
    critical = var.response_time_threshold / 1000  # Convertir ms a segundos
    warning  = var.response_time_threshold * 0.8 / 1000
  }

  notify_no_data    = false
  evaluation_delay  = 60
  
  include_tags = true
  
  tags = [
    "env:${var.environment}",
    "service:${var.service_name}",
    "tipo:rendimiento",
    "managed-by:terraform"
  ]
}