job "Filestatusexporter" {
  datacenters = ["dc1"]

  group "exporter" {
       count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 9144
      }
    }

	restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }	
	
	
	task "filestatusexporter" {
      driver = "docker"

      config {
        image = "truecommercedk/filestatus_exporter:v0.0.6"
		ports = ["http"]
      }
	  
	  env {
		MT_HOST = "service.b2bi.dk"
      }
	  
	  resources {
        cpu    = 10 # MHz
        memory = 64 # MB
      }
	  
  service {
        name = "filestatusexporter"
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
