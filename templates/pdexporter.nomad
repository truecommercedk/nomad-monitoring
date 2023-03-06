job "Pagerdutyexporter" {
  datacenters = ["dc1"]

  group "exporter" {
      count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 9143
      }
    }

	restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }	
	
	
	task "server" {
      driver = "docker"

      template {
        destination = "$${NOMAD_SECRETS_DIR}/env.vars"
        env         = true
        change_mode = "noop"
        data        = <<EOF
				{{- with nomadVar "nomad/jobs/pdexporter" -}}
				PD_APIKEY = {{.pd_apikey}}
				PD_EPID	= {{.pd_epid}}
				{{- end -}}
				EOF
      }

      config {
        image = "truecommercedk/pagerduty_exporter:v1.0.2"
		ports = ["http"]
      }
	  
	  env {
        PORT = "$${NOMAD_PORT_http}"
      }
	  
	  resources {
        cpu    = 10 # MHz
        memory = 64 # MB
      }
	  
	    service {
        name = "pagerdutyexporter"
        port = "http"
        tags = ["exporter","monitoring","prometheus"]
		
		check {
          name     = "Exporter HTTP"
          type     = "http"
          path     = "/"
          interval = "5s"
          timeout  = "2s"

          check_restart {
            limit           = 2
            grace           = "60s"
            ignore_warnings = false
          }
        }

      }


    }

  }

}
