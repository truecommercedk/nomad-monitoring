job "farmer-webapp" {
  datacenters = ["dc2", "dc1"]

  #	affinity {
  #		attribute = "$${node.datacenter}"
  #		value     = "dc2"
  #		weight    = 100
  #	}

  group "farmerapp" {
    count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 8080
      }
    }

    task "server" {
      driver = "docker"
      env {
        PROM_HOST    = "alertmanager.service.dc1.consul:9093"
        GRAFANA_HOST = "grafana.service.dc1.consul:3000"
        NODE_IP      = "$${NOMAD_IP_http}"
        PORT_APP     = "$${NOMAD_PORT_http}"
        HOST         = "mariadb-server.service.dc1.consul"
        PORT         = "3306"
      }
      template {
        destination = "$${NOMAD_SECRETS_DIR}/env.vars"
        env         = true
        change_mode = "noop"
        data        = <<EOF
				{{- with nomadVar "nomad/jobs/farmer" -}}
				DBUSER		= {{.db_user}}
				DBPASS	= {{.db_pass}}
				LDAP_SERVER = {{.ldap_server}}
				LDAP_BASE_DN = {{.ldap_base_dn}}
				{{- end -}}
				EOF
      }
      config {
        image = "truecommercedk/farmer:v3.0.7"
        ports = ["http"]
      }
      resources {
        cpu    = 10 # MHz
        memory = 64 # MB
      }
    }
  }
}