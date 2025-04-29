resource "datadog_monitor" "VM_GCP_Uso_de_cpu_Anomal" {
  new_group_delay = 60
  require_full_window = false
  monitor_thresholds {
    critical = 0.6
    critical_recovery = 0.3  # Cambiado de 0 a 0.3 para evitar superposición
  }
  monitor_threshold_windows {
    recovery_window = "last_15m"
    trigger_window = "last_1h"
  }
  name = "[VM GCP] Uso de cpu :: Anomal"
  type = "query alert"
  query = <<EOT
avg(last_1d):anomalies(100 - avg:system.cpu.idle{project:ancient-tractor-452505-b5} by {host}, 'basic', 2, direction='below', interval=300, alert_window='last_1h', count_default_zero='true', seasonality='hourly') >= 0.6
EOT
  message = <<EOT
@team-teleton 
ALERTA: Anomalia en uso de CPU en {{host.name}} - {{value}}% 
Detalles:
- Host: {{host.name}}
- CPU usado: {{value}} %
- Proyecto: ancient-tractor-452505-b5
- Timestamp: {{last_triggered_at}}
EOT
  
  # Etiquetas para mantener consistencia
  tags = [
    "type:vm",
    "env:${var.environment}",
    "managed-by:terraform",
    "provider:gcp"
  ]
  
  include_tags = true
}