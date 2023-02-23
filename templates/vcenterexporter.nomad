job "vcenterexporter" {
  datacenters = ["dc1"]

  group "exporter" {
      count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 9272
      }
    }

	restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }	
	
	task "vcenterexporterserver" {
      driver = "docker"

      config {
        image = "pryorda/vmware_exporter:latest"
		ports = ["http"]
      }
	    env {
			VSPHERE_USER="wmwaremon@valhal.lan"
			VSPHERE_PASSWORD="Test123!"
			VSPHERE_HOST="admvcs001.valhal.lan"
			VSPHERE_IGNORE_SSL="True"
			VSPHERE_SPECS_SIZE="2000"
		}

	  resources {
        cpu    = 20 # MHz
        memory = 1024 # MB
      }
	  
	    service {
        name = "vcenterexporter"
        port = "http"
        tags = ["exporter","monitoring","prometheus"]

      }


    }

  }

}
