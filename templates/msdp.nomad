job "msdp-webapp" {
	datacenters = ["dc1"]
	group "msdpapp" {
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
      name = "MsdpWebApp"
      port = "http"

      check {
        type     = "http"
        path     = "/users/login"
        interval = "2s"
        timeout  = "2s"
      }
    }
	
		task "server" {
			driver = "docker"
			env {
					DBUSER = "msdp"
					DBPASS = "123456"
					LDAP_SERVER = "admdc001.valhal.lan"
					LDAP_BASE_DN = "CN=MonitoringUsers,OU=User Groups,OU=DK,DC=Valhal,DC=lan"
					PRTG_HOST="prtg-prod-03.b2bi.dk"
					PRTG_USER="apiuser"
					PRTG_PASS="yP7XqkW3PhaUP3DX"
					PORT_APP = "$${NOMAD_PORT_http}"
					NODE_IP = "$${NOMAD_IP_http}"
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
				image = "truecommercedk/msdp:latest"
				ports = ["http"]
			}
			resources {
				cpu    = 10 # MHz
				memory = 64 # MB
			}			
		}  
	}
}
