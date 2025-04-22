# Monitor para sitio que siempre responde OK (200)
resource "datadog_synthetics_test" "sitio_siempre_disponible" {
  name    = "${var.service_name}-test-siempre-disponible-${var.environment}"
  type    = "api"
  subtype = "http"

  request_definition {
    method  = "GET"
    url     = "https://httpstat.us/200"
    timeout = 15
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  locations = ["aws:eu-central-1", "aws:us-east-1"]
  status    = "live"

  message = "Este test siempre debería pasar, ya que httpstat.us/200 siempre devuelve 200. Si falla, revisa tu conectividad. ${var.team_email}"
  tags    = ["prueba:disponibilidad", "env:${var.environment}", "managed-by:terraform"]

  options_list {
    tick_every = 300

    retry {
      count    = 2
      interval = 300
    }

    monitor_options {
      renotify_interval = 120
    }
  }
}

# Monitor para sitio que siempre falla (503)
resource "datadog_synthetics_test" "sitio_siempre_indisponible" {
  name    = "${var.service_name}-test-siempre-indisponible-${var.environment}"
  type    = "api"
  subtype = "http"

  request_definition {
    method  = "GET"
    url     = "https://httpstat.us/503"
    timeout = 15
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "503"
  }

  locations = ["aws:eu-central-1"]
  status    = "live"

  message = "Esta prueba está configurada para esperar un 503. Si pasa, tu monitor funciona correctamente. ${var.team_email}"
  tags    = ["prueba:indisponibilidad", "env:${var.environment}", "managed-by:terraform"]

  options_list {
    tick_every = 900
    retry {
      count    = 2
      interval = 300
    }

    monitor_options {
      renotify_interval = 0
    }
  }
}

# Monitor para detectar 404
resource "datadog_synthetics_test" "sitio_not_found" {
  name    = "${var.service_name}-test-not-found-${var.environment}"
  type    = "api"
  subtype = "http"

  request_definition {
    method  = "GET"
    url     = "https://httpstat.us/404"
    timeout = 15
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "404"
  }

  locations = ["aws:eu-central-1"]
  status    = "live"

  message = "Esta prueba está configurada para esperar un 404. Útil para simular recursos no encontrados. ${var.team_email}"
  tags    = ["prueba:not-found", "env:${var.environment}", "managed-by:terraform"]

  options_list {
    tick_every = 900

    retry {
      count    = 2
      interval = 300
    }

    monitor_options {
      renotify_interval = 0
    }
  }
}



# Monitor para sitio con retardo alto (5 segundos)
resource "datadog_synthetics_test" "retardo_alto" {
  name    = "${var.service_name}-test-retardo-alto-${var.environment}"
  type    = "api"
  subtype = "http"

  request_definition {
    method  = "GET"
    url     = "https://httpstat.us/200?sleep=5000"
    timeout = 10
  }

  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }

  assertion {
    type     = "responseTime"
    operator = "lessThan"
    target   = "6000"
  }

  locations = ["aws:eu-central-1"]
  status    = "live"

  message = "El sitio de prueba con retardo de 5 segundos está respondiendo más lento de lo esperado. ${var.team_email}"
  tags    = ["prueba:retardo-alto", "env:${var.environment}", "managed-by:terraform"]

  options_list {
    tick_every = 1800

    retry {
      count    = 2
      interval = 300
    }

    monitor_options {
      renotify_interval = 120
    }
  }
}