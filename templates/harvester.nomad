job "Harvester" {
	datacenters = ["dc1"]

	group "harvester1" {
	 count = 1

    network {
		dns {
			servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
		}
      	port "http" {
        static = 12990
      }
    }
	
	service {
      name = "harvester1"
      port = "http"

      check {
        type     = "http"
        path     = "/"
        interval = "2s"
        timeout  = "2s"
      }
    }

		task "poller" {
			driver = "docker"

			template {
				data = <<EOTC
Admin:
Tools:
Exporters:
  prometheus:
    exporter: Prometheus
    local_http_addr: 0.0.0.0
    port: 12990
  prometheus1:
    exporter: Prometheus
    port_range: 13000-14000

Defaults:
  collectors:
    - Zapi
    - ZapiPerf
    - Ems
  use_insecure_tls: true

Pollers:
   cluster-01:
     datacenter: DC-01
     addr: 10.16.20.55
     auth_style: basic_auth
     username: netappprtg
     password: "#Inf04All#"
     use_insecure_tls: true  # Disable TLS verification when connecting to ONTAP cluster
     exporters:
       - prometheus
EOTC
        destination = "/local/harvest.yml"
        change_mode   = "signal"
        change_signal = "SIGHUP"
			}

			config {
				image = "cr.netapp.io/harvest:latest"
				ports = ["http"]
				args = [
					"--poller=cluster-01",
					"--promPort=12990",
					"--config=/local/harvest.yml"
				]
			}
			resources {
				cpu    = 10 # MHz
				memory = 64 # MB
			}
		}

	}

	group "harvester2" {
		count = 1

		network {
			dns {
				servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
			}
			port "http" {
				static = 12991
			}
		}

		service {
			name = "harvester2"
			port = "http"

			check {
				type     = "http"
				path     = "/"
				interval = "2s"
				timeout  = "2s"
			}
		}


		task "poller" {
			driver = "docker"

			template {
				data          = <<EOTC
Admin:
Tools:
Exporters:
  prometheus:
    exporter: Prometheus
    local_http_addr: 0.0.0.0
    port: 12990
  prometheus1:
    exporter: Prometheus
    port_range: 13000-14000

Defaults:
  collectors:
    - Zapi
    - ZapiPerf
    - Ems
  use_insecure_tls: true

Pollers:
   cluster-02:
     datacenter: DC-01
     addr: 10.16.20.25
     auth_style: basic_auth
     username: netappprtg
     password: "#Inf04All#"
     use_insecure_tls: true  # Disable TLS verification when connecting to ONTAP cluster
     exporters:
       - prometheus
EOTC
				destination   = "/local/harvest.yml"
				change_mode   = "signal"
				change_signal = "SIGHUP"
			}

			config {
				image = "cr.netapp.io/harvest:latest"
				ports = ["http"]
				args  = [
					"--poller=cluster-02",
					"--promPort=12991",
					"--config=/local/harvest.yml"
				]
			}
			resources {
				cpu    = 10 # MHz
				memory = 64 # MB
			}
		}
	}

	group "harvester3" {
			count = 1

			network {
				dns {
					servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
				}
				port "http" {
					static = 12992
				}
			}

			service {
				name = "harvester3"
				port = "http"

				check {
					type     = "http"
					path     = "/"
					interval = "2s"
					timeout  = "2s"
				}
			}


			task "poller" {
				driver = "docker"

				template {
					data          = <<EOTC
Admin:
Tools:
Exporters:
  prometheus:
    exporter: Prometheus
    local_http_addr: 0.0.0.0
    port: 12990
  prometheus1:
    exporter: Prometheus
    port_range: 13000-14000

Defaults:
  collectors:
    - Zapi
    - ZapiPerf
    - Ems
  use_insecure_tls: true

Pollers:
   cluster-03:
     datacenter: DC-01
     addr: 10.16.20.10
     auth_style: basic_auth
     username: netappprtg
     password: "#Inf04All#"
     use_insecure_tls: true  # Disable TLS verification when connecting to ONTAP cluster
     exporters:
       - prometheus
EOTC
					destination   = "/local/harvest.yml"
					change_mode   = "signal"
					change_signal = "SIGHUP"
				}

				config {
					image = "cr.netapp.io/harvest:latest"
					ports = ["http"]
					args  = [
						"--poller=cluster-03",
						"--promPort=12992",
						"--config=/local/harvest.yml"
					]
				}
				resources {
					cpu    = 10 # MHz
					memory = 64 # MB
				}
			}
		}

	group "harvester4" {
				count = 1

				network {
					dns {
						servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
					}
					port "http" {
						static = 12993
					}
				}

				service {
					name = "harvester4"
					port = "http"

					check {
						type     = "http"
						path     = "/"
						interval = "2s"
						timeout  = "2s"
					}
				}


				task "poller" {
					driver = "docker"

					template {
						data          = <<EOTC
Admin:
Tools:
Exporters:
  prometheus:
    exporter: Prometheus
    local_http_addr: 0.0.0.0
    port: 12990
  prometheus1:
    exporter: Prometheus
    port_range: 13000-14000

Defaults:
  collectors:
    - Zapi
    - ZapiPerf
    - Ems
  use_insecure_tls: true

Pollers:
   cluster-04:
     datacenter: DC-02
     addr: 10.16.20.40
     auth_style: basic_auth
     username: netappprtg
     password: "#Inf04All#"
     use_insecure_tls: true  # Disable TLS verification when connecting to ONTAP cluster
     exporters:
       - prometheus
EOTC
						destination   = "/local/harvest.yml"
						change_mode   = "signal"
						change_signal = "SIGHUP"
					}

					config {
						image = "cr.netapp.io/harvest:latest"
						ports = ["http"]
						args  = [
							"--poller=cluster-04",
							"--promPort=12993",
							"--config=/local/harvest.yml"
						]
					}
					resources {
						cpu    = 10 # MHz
						memory = 64 # MB
					}
				}
			}

	group "harvester5" {
					count = 1

					network {
						dns {
							servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
						}
						port "http" {
							static = 12994
						}
					}

					service {
						name = "harvester5"
						port = "http"

						check {
							type     = "http"
							path     = "/"
							interval = "2s"
							timeout  = "2s"
						}
					}


					task "poller" {
						driver = "docker"

						template {
							data          = <<EOTC
Admin:
Tools:
Exporters:
  prometheus:
    exporter: Prometheus
    local_http_addr: 0.0.0.0
    port: 12990
  prometheus1:
    exporter: Prometheus
    port_range: 13000-14000

Defaults:
  collectors:
    - Zapi
    - ZapiPerf
    - Ems
  use_insecure_tls: true

Pollers:
   cluster-05:
     datacenter: DC-02
     addr: 10.16.20.26
     auth_style: basic_auth
     username: netappprtg
     password: "#Inf04All#"
     use_insecure_tls: true  # Disable TLS verification when connecting to ONTAP cluster
     exporters:
       - prometheus
EOTC
							destination   = "/local/harvest.yml"
							change_mode   = "signal"
							change_signal = "SIGHUP"
						}

						config {
							image = "cr.netapp.io/harvest:latest"
							ports = ["http"]
							args  = [
								"--poller=cluster-05",
								"--promPort=12994",
								"--config=/local/harvest.yml"
							]
						}
						resources {
							cpu    = 10 # MHz
							memory = 64 # MB
						}
					}
				}

	group "harvester6" {
		count = 1

		network {
			dns {
				servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
			}
			port "http" {
				static = 12995
			}
		}

		service {
			name = "harvester6"
			port = "http"

			check {
				type     = "http"
				path     = "/"
				interval = "2s"
				timeout  = "2s"
			}
		}


		task "poller" {
			driver = "docker"

			template {
				data = <<EOTC
Admin:
Tools:
Exporters:
  prometheus:
    exporter: Prometheus
    local_http_addr: 0.0.0.0
    port: 12990
  prometheus1:
    exporter: Prometheus
    port_range: 13000-14000

Defaults:
  collectors:
    - Zapi
    - ZapiPerf
    - Ems
  use_insecure_tls: true

Pollers:
   cluster-06:
     datacenter: DC-02
     addr: 10.16.20.15
     auth_style: basic_auth
     username: netappprtg
     password: "#Inf04All#"
     use_insecure_tls: true  # Disable TLS verification when connecting to ONTAP cluster
     exporters:
       - prometheus
EOTC
				destination = "/local/harvest.yml"
				change_mode   = "signal"
				change_signal = "SIGHUP"
			}

			config {
				image = "cr.netapp.io/harvest:latest"
				ports = ["http"]
				args = [
					"--poller=cluster-06",
					"--promPort=12995",
					"--config=/local/harvest.yml"
				]
			}
			resources {
				cpu    = 10 # MHz
				memory = 64 # MB
			}
		}


	}

}