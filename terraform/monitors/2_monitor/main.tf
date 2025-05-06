resource "datadog_monitor" "vm_gcp_monitor" {
  include_tags = false
  new_group_delay = 60
  notify_audit = true
  require_full_window = false
  monitor_thresholds {
    critical = 90
    warning = 80
  }
  name = "[VM GCP] Uso de disco :: Critical"
  type = "query alert"
  query = <<EOT
avg(last_5m):100 * ( max:system.disk.used{project:ancient-tractor-452505-b5} by {host} / max:system.disk.total{project:ancient-tractor-452505-b5} by {host} ) > 90
EOT
  message = <<EOT
@team-teleton 
ALERTA: Uso de disco alto en {{host.name}} - {{value}}% usado

Detalles:
- Host: {{host.name}}
- Espacio usado: {{value}} %
- Proyecto: ancient-tractor-452505-b5
- Timestamp: {{last_triggered_at}}
EOT
}