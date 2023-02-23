job "mariadb" {
  datacenters = ["dc1"]
  type        = "service"

  group "mariadb-server" {
    count = 1

    volume "mariadb" {
      type      = "host"
      read_only = false
      source    = "mariadb_host"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "mariadb-server" {
      driver = "docker"

      volume_mount {
        volume      = "mariadb"
        destination = "/var/lib/mysql"
        read_only   = false
      }

      env = {
		"MARIADB_ROOT_PASSWORD" = "rootroot"
		"MARIADB_USER" = "farmer"
		"MARIADB_PASSWORD" = "123456"
		"MARIADB_DATABASE" = "farmer"
		"TZ" = "Europe/Copenhagen"
      }

      config {
        image = "mariadb:10.10.2"

        ports = ["db"]
      }

      resources {
        cpu    = 10
        memory = 256
      }

      service {
        name = "mariadb-server"
        port = "db"

        check {
          type     = "tcp"
          interval = "10s"
          timeout  = "2s"
        }
      }
    }
    network {
      port "db" {
        static = 3306
      }
    }
  }
}
