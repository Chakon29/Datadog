resource "datadog_dashboard" "response_time_detail" {
  title       = "${var.service_name}-tiempos-respuesta-${var.environment}"
  description = "Dashboard detallado de tiempos de respuesta para ${var.service_name} en ambiente ${var.environment}"
  layout_type = "ordered"

  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Análisis de Tiempos de Respuesta"

      widget {
        timeseries_definition {
          title = "Tiempo de Respuesta - Comparativa"
          request {
            q            = "avg:http.response_time{test_id:${datadog_synthetics_test.sitio_siempre_disponible.id}}"
            display_type = "line"
            style {
              palette    = "cool"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          request {
            q            = "avg:http.response_time{test_id:${datadog_synthetics_test.retardo_alto.id}}"
            display_type = "line"
            style {
              palette    = "warm"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          yaxis {
            scale        = "linear"
            label        = "ms"
            min          = "0"
            include_zero = true
          }
          marker {
            display_type = "error dashed"
            value        = var.response_time_threshold
            label        = "Umbral Crítico"
          }
          marker {
            display_type = "warning dashed"
            value        = var.response_time_threshold * 0.8
            label        = "Umbral Warning"
          }
          live_span = "1d"
        }
      }

      widget {
        query_value_definition {
          title = "Tiempo Promedio de Respuesta"
          request {
            q          = "avg:http.response_time{service:${var.service_name},env:${var.environment}}"
            aggregator = "avg"
            conditional_formats {
              comparator = "<"
              value      = var.response_time_threshold * 0.5
              palette    = "white_on_green"
            }
            conditional_formats {
              comparator = ">"
              value      = var.response_time_threshold * 0.8
              palette    = "white_on_yellow"
            }
            conditional_formats {
              comparator = ">"
              value      = var.response_time_threshold
              palette    = "white_on_red"
            }
          }
          autoscale  = true
          precision  = 2
          text_align = "center"
          live_span  = "1h"
        }
      }
    }
  }

  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Distribución de Tiempos de Respuesta"

      widget {
        distribution_definition {
          title = "Distribución de Tiempos"
          request {
            q = "avg:http.response_time{service:${var.service_name},env:${var.environment}}"
            style {
              palette = "dog_classic"
            }
          }
          live_span = "1d"
        }
      }

      widget {
        heatmap_definition {
          title = "Heatmap de Tiempos de Respuesta"
          request {
            q = "avg:http.response_time{service:${var.service_name},env:${var.environment}}"
            style {
              palette = "dog_classic"
            }
          }
          live_span = "1d"
        }
      }
    }
  }

  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Tiempos por Prueba Sintética"

      widget {
        toplist_definition {
          title = "Pruebas por Tiempo de Respuesta"
          request {
            q = "top(avg:http.response_time{test_id:*} by {test_name}, 10, 'mean', 'desc')"
            conditional_formats {
              comparator = "<"
              value      = var.response_time_threshold * 0.5
              palette    = "white_on_green"
            }
            conditional_formats {
              comparator = ">"
              value      = var.response_time_threshold * 0.8
              palette    = "white_on_yellow"
            }
            conditional_formats {
              comparator = ">"
              value      = var.response_time_threshold
              palette    = "white_on_red"
            }
          }
          live_span = "1d"
        }
      }

      widget {
        timeseries_definition {
          title = "Evolución de Tiempo por Prueba"
          request {
            q            = "anomalies(avg:http.response_time{test_id:*} by {test_name}, 'basic', 2)"
            display_type = "line"
          }
          live_span = "1w"
        }
      }
    }
  }

  widget {
    note_definition {
      content          = <<EOT
Dashboard de análisis de rendimiento creado mediante Terraform.
Umbral configurado: **${var.response_time_threshold}ms**
Contacto: ${var.team_email}
EOT
      background_color = "gray"
      font_size        = "14"
      text_align       = "center"
      show_tick        = true
      tick_pos         = "bottom"
      tick_edge        = "left"
    }
  }

  template_variable {
    name     = "environment"
    prefix   = "env"
    defaults = [var.environment]
  }

  template_variable {
    name     = "service"
    prefix   = "service"
    defaults = [var.service_name]
  }
}