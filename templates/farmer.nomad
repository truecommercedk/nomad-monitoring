job "farmer-webapp" {
	datacenters = ["dc2","dc1"]

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
        to = -1
      }
    }
	
	service {
      name = "FarmerWebApp"
      port = "http"

      check {
        type     = "http"
        path     = "/metrics"
        interval = "2s"
        timeout  = "2s"
      }
    }
	
		task "server" {
			driver = "docker"
			env {
					DBUSER = "farmer"
					DBPASS = "123456"
					LDAP_SERVER = "admdc001.valhal.lan"
					LDAP_BASE_DN = "CN=MonitoringAdmins,OU=User Groups,OU=DK,DC=Valhal,DC=lan"
					PROM_HOST = "alertmanager.service.dc1.consul:9093"
					GRAFANA_HOST = "grafana.service.dc1.consul:3000"
					GRAFANA_KEY = "glsa_qgZwqiJqa6hJZeijKNe7HhIAjjgY24CG_b364241b"
				NODE_IP = "$${NOMAD_IP_http}"
				PORT_APP = "$${NOMAD_PORT_http}"
				    HOST = "mariadb-server.service.dc1.consul"
				    PORT = "3306"
				}
			#template {
			#	data = <<EOH
			#	HOST="{{ range service "mariadb-server" }}{{ .Address }}{{ end }}"
			#	PORT="{{ range service "mariadb-server" }}{{ .Port }}{{ end }}"
			#	EOH
			#	destination = "mariadb-server.env"
			#	env         = true
			#}
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