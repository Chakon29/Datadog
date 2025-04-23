resource "datadog_dashboard" "service_overview" {
  title        = "${var.service_name}-dashboard-${var.environment}"
  description  = "Dashboard general de monitoreo para ${var.service_name} en ambiente ${var.environment}"
  layout_type  = "ordered"


  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Pruebas Sintéticas - Estado Actual"

      widget {
        manage_status_definition {
          summary_type    = "monitors"
          display_format  = "counts"
          color_preference = "background"
          hide_zero_counts = true
          query           = "tag:(managed-by:terraform env:${var.environment} service:${var.service_name})"
          sort            = "status,asc"
          show_last_triggered = true
        }
      }
    }
  }

  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Detalles de Pruebas Sintéticas"

      widget {
        alert_graph_definition {
          alert_id      = datadog_synthetics_test.sitio_siempre_disponible.monitor_id
          viz_type      = "timeseries"
          title         = "Sitio Siempre Disponible (200)"
          live_span     = "1h"
        }
      }

      widget {
        alert_graph_definition {
          alert_id      = datadog_synthetics_test.sitio_siempre_indisponible.monitor_id
          viz_type      = "timeseries"
          title         = "Sitio Siempre Indisponible (503)"
          live_span     = "1h"
        }
      }

      widget {
        alert_graph_definition {
          alert_id      = datadog_synthetics_test.sitio_not_found.monitor_id
          viz_type      = "timeseries"
          title         = "Sitio Not Found (404)"
          live_span     = "1h"
        }
      }

      widget {
        alert_graph_definition {
          alert_id      = datadog_synthetics_test.retardo_alto.monitor_id
          viz_type      = "timeseries"
          title         = "Sitio con Retardo Alto (5s)"
          live_span     = "1h"
        }
      }
    }
  }

  widget {
    note_definition {
      content          = "Dashboard creado automáticamente mediante Terraform.\nContacto: ${var.team_email}"
      background_color = "gray"
      font_size        = "14"
      text_align       = "center"
      show_tick        = true
      tick_pos         = "bottom"
      tick_edge        = "left"
    }
  }

  widget {
    timeseries_definition {
      title = "Tiempos de Respuesta por Sitio"
      request {
        q            = "avg:http.response_time{test_id:${datadog_synthetics_test.sitio_siempre_disponible.id}}"
        display_type = "line"
        style {
          palette     = "dog_classic"
          line_type   = "solid"
          line_width  = "normal"
        }
      }
      request {
        q            = "avg:http.response_time{test_id:${datadog_synthetics_test.retardo_alto.id}}"
        display_type = "line"
        style {
          palette     = "warm"
          line_type   = "solid"
          line_width  = "normal"
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
        label        = "Umbral de Alerta"
      }
      live_span = "1d"
    }
  }

  # Añadir un widget para monitoreo de disponibilidad
  widget {
    servicemap_definition {
      service             = var.service_name
      filters             = ["env:${var.environment}"]
      title               = "Mapa de Servicios"
    }
  }

  # Añadir enlaces a las pruebas sintéticas
  widget {
    group_definition {
      layout_type = "ordered"
      title       = "Enlaces a Pruebas Sintéticas"

      widget {
        toplist_definition {
          title = "Enlaces Directos"
          request {
            q            = "avg:http.response_time{test_id:*}"
            style {
              palette     = "purple"
            }
          }
          live_span = "1h"
        }
      }

      widget {
        note_definition {
          content          = <<EOT
## Enlaces a Pruebas Sintéticas

* [Sitio Siempre Disponible (200)](https://app.datadoghq.com/synthetics/details/${datadog_synthetics_test.sitio_siempre_disponible.id})
* [Sitio Siempre Indisponible (503)](https://app.datadoghq.com/synthetics/details/${datadog_synthetics_test.sitio_siempre_indisponible.id})
* [Sitio Not Found (404)](https://app.datadoghq.com/synthetics/details/${datadog_synthetics_test.sitio_not_found.id})
* [Sitio con Retardo Alto (5s)](https://app.datadoghq.com/synthetics/details/${datadog_synthetics_test.retardo_alto.id})
EOT
          background_color = "white"
          font_size        = "14"
          text_align       = "left"
          show_tick        = false
        }
      }
    }
  }

  template_variable {
    name   = "environment"
    prefix = "env"
    defaults = [var.environment]
  }

  template_variable {
    name   = "service"
    prefix = "service"
    defaults = [var.service_name]
  }
}

# Recurso para un dashboard de SLOs si quieres expandirlo en el futuro
resource "datadog_dashboard" "service_slo" {
  title        = "${var.service_name}-slo-dashboard-${var.environment}"
  description  = "Dashboard de SLOs para ${var.service_name} en ambiente ${var.environment}"
  layout_type  = "ordered"

  widget {
    note_definition {
      content          = <<EOT
# Dashboard de SLOs

Este dashboard está preparado para mostrar los SLOs del servicio ${var.service_name} en el ambiente ${var.environment}.

Para completar este dashboard, crea recursos de SLO en Datadog y referéncialos aquí.
EOT
      background_color = "blue"
      font_size        = "14"
      text_align       = "center"
      show_tick        = true
      tick_pos         = "bottom"
      tick_edge        = "left"
    }
  }
}