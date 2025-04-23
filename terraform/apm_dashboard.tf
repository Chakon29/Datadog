resource "datadog_dashboard" "apm_dashboard" {
  title       = "${var.service_name}-apm-dashboard-${var.environment}"
  description = "Dashboard de APM para ${var.service_name} en ambiente ${var.environment}"
  layout_type = "ordered"

  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Visión General de APM"

      widget {
        timeseries_definition {
          title = "Tráfico total"
          request {
            q            = "sum:trace.${var.service_name}.hits{env:${var.environment}} by {resource_name}.rollup(sum)"
            display_type = "bars"
            style {
              palette    = "dog_classic"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          yaxis {
            scale        = "linear"
            label        = "requests"
            include_zero = true
          }
          live_span = "1h"
        }
      }

      widget {
        timeseries_definition {
          title = "Errores"
          request {
            q            = "sum:trace.${var.service_name}.errors{env:${var.environment}} by {resource_name}.rollup(sum)"
            display_type = "bars"
            style {
              palette    = "warm"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          yaxis {
            scale        = "linear"
            label        = "errors"
            include_zero = true
          }
          live_span = "1h"
        }
      }
    }
  }

  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Latencia por Endpoint"

      widget {
        timeseries_definition {
          title = "Latencia por Recurso"
          request {
            q            = "avg:trace.${var.service_name}.index_request{env:${var.environment}} by {resource_name}"
            display_type = "line"
            style {
              palette    = "cool"
              line_type  = "solid"
              line_width = "normal"
            }
          }
          request {
            q            = "avg:trace.${var.service_name}.slow_request{env:${var.environment}} by {resource_name}"
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
            value        = "${var.response_time_threshold}"
            label        = "Umbral crítico"
          }
          live_span = "1h"
        }
      }

      widget {
        toplist_definition {
          title = "Endpoints más lentos"
          request {
            q = "top(avg:trace.${var.service_name}.http.request{env:${var.environment}} by {resource_name}, 10, 'mean', 'desc')"
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
          live_span = "1h"
        }
      }
    }
  }

  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Distribución de Códigos HTTP"

      widget {
        timeseries_definition {
          title = "Códigos de estado por minuto"
          request {
            q            = "sum:trace.${var.service_name}.hits{env:${var.environment}} by {http.status_code}.rollup(sum)"
            display_type = "bars"
          }
          live_span = "1h"
        }
      }

      widget {
        query_value_definition {
          title = "Tasa de errores"
          request {
            q          = "100 * sum:trace.${var.service_name}.errors{env:${var.environment}}.rollup(sum) / sum:trace.${var.service_name}.hits{env:${var.environment}}.rollup(sum)"
            aggregator = "avg"
            conditional_formats {
              comparator = "<"
              value      = 1
              palette    = "white_on_green"
            }
            conditional_formats {
              comparator = ">"
              value      = 5
              palette    = "white_on_yellow"
            }
            conditional_formats {
              comparator = ">"
              value      = 10
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
      title       = "Rendimiento del Servicio"

      widget {
        servicemap_definition {
          service     = var.service_name
          filters     = ["env:${var.environment}"]
          title       = "Mapa de Servicio"
        }
      }

      widget {
        trace_service_definition {
          service     = var.service_name
          env         = var.environment
          span_name   = "default" # Specify the span name here
          title       = "Análisis de APM"
          live_span   = "1h"
          display_format = "three_columns"
          show_hits = true
          show_errors = true
          show_latency = true
          show_breakdown = true
          show_distribution = true
          show_resource_list = true
        }
      }
    }
  }

  widget {
    note_definition {
      content          = <<EOT
Dashboard de APM para ${var.service_name} en el entorno ${var.environment}.
Métricas principales de rendimiento y disponibilidad de la aplicación.

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