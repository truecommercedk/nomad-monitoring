job "blackboxexporter" {
  datacenters = ["dc1"]

  group "exporter" {
       count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 9115
      }
    }
	
	restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }
	
	task "blackboxexporterserver" {
      driver = "docker"

      config {
        image = "quay.io/prometheus/blackbox-exporter:v0.23.0"
		 args = [
          "--config.file=/local/blackbox.yml"
        ]
		ports = ["http"]
      }
	  
      template {
        data = <<EOF
modules:
  http_2xx:
    prober: http
    timeout: 5s
    http:
      valid_http_versions: ["HTTP/1.1", "HTTP/2.0"]
      valid_status_codes: []
      method: GET
      follow_redirects: true
      fail_if_ssl: false
      fail_if_not_ssl: false
      tls_config:
        insecure_skip_verify: false
      preferred_ip_protocol: "ip4"
      ip_protocol_fallback: false
  tcp_connect:
    prober: tcp
    timeout: 5s
EOF

        destination   = "local/blackbox.yml"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
	  	  
	  resources {
        cpu    = 50 # MHz
        memory = 512 # MB
      }
	  
	   service {
        name = "blackboxexporter"
        port = "http"
        tags = ["exporter","monitoring","prometheus"]

      }


    }

  }

}
