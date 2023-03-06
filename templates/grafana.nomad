job "Grafana" {
  datacenters = ["dc1"]
  type        = "service"

  group "grafana" {
    count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 3000
      }
    }

    volume "grafanadata" {
      type      = "host"
      read_only = false
      source    = "grafana_nfs"
    }

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    task "grafana" {
      driver = "docker"
      user = "root"

      volume_mount {
        volume      = "grafanadata"
        destination = "/var/lib/grafana"
        read_only   = false
      }
      template {
        data        = <<EOTC
apiVersion: 1
datasources:
  - name: Prometheus
    type: prometheus
    access: proxy
    url: http://prometheus.service.dc1.consul:9090
    jsonData:
      timeInterval: 60s
      timeout: 60
EOTC
        destination = "local/provisioning/datasources/ds.yaml"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      template {
        data        = <<EOTC
apiVersion: 1

providers:
- name: 'default'
  type: file
  updateIntervalSeconds: 30
  options:
    path: /local/dashboards
    foldersFromFilesStructure: true
EOTC
        destination = "local/provisioning/dashboards/dashboards.yaml"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      config {
        image = "grafana/grafana:9.3.2"
        ports = ["http"]
      }

      env {
        GF_SECURITY_DISABLE_INITIAL_ADMIN_CREATION = "true"
        GF_AUTH_ANONYMOUS_ENABLED = "true"
        GF_AUTH_ANONYMOUS_ORG_ROLE = "Admin"
        GF_AUTH_DISABLE_SIGNOUT_MENU = "true"
        GF_AUTH_DISABLE_LOGIN_FORM = "true"
        GF_LOG_LEVEL          = "DEBUG"
        GF_LOG_MODE           = "console"
        GF_SERVER_HTTP_PORT   = "$${NOMAD_PORT_http}"
        GF_PATHS_PROVISIONING = "/local/provisioning"
      }
	  
#      artifact {
#        source      = "github.com/truecommercedk/nomad-monitoring/grafana/provisioning"
#        destination = "local/provisioning/"
#      }

      artifact {
        source      = "github.com/truecommercedk/nomad-monitoring/grafana/dashboards"
        destination = "local/dashboards/"
      }	  

      resources {
        cpu    = 100
        memory = 100
      }

      service {
        name = "grafana"
        port = "http"
        tags = ["monitoring","prometheus"]

        check {
          name     = "Grafana HTTP"
          type     = "http"
          path     = "/api/health"
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