job "mariadb" {
  datacenters = ["dc1"]
  type        = "service"

  group "mariadb-server" {
    count = 1

    volume "mariadb" {
      type      = "host"
      read_only = false
      source    = "mariadb_nfs"
    }

    volume "mariadbbackup" {
      type      = "host"
      read_only = false
      source    = "mariadbbackup_nfs"
    }

    restart {
      attempts = 10
      interval = "5m"
      delay    = "25s"
      mode     = "delay"
    }

    task "server" {
      driver = "docker"
      user ="nobody"

      volume_mount {
        volume      = "mariadb"
        destination = "/var/lib/mysql"
        read_only   = false
      }

      env = {
        "MARIADB_ALLOW_EMPTY_ROOT_PASSWORD" = "true"
		"TZ" = "Europe/Copenhagen"
      }

      config {
        image = "mariadb:10.10.2"
        ports = ["db"]
        volumes = [
          "docker-entrypoint-initdb.d/:/docker-entrypoint-initdb.d/",
        ]
      }

      template {
        data = <<EOH
  CREATE DATABASE farmer;
  CREATE USER 'farmer'@'%' IDENTIFIED BY '123456';
  GRANT ALL PRIVILEGES ON farmer.* TO 'farmer'@'%';
  CREATE DATABASE msdp;
  CREATE USER 'msdp'@'%' IDENTIFIED BY '123456';
  GRANT ALL PRIVILEGES ON msdp.* TO 'msdp'@'%';
  EOH
        destination = "/docker-entrypoint-initdb.d/db.sql"
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

    task "backup" {
      driver = "docker"
      user ="nobody"

      volume_mount {
        volume      = "mariadbbackup"
        destination = "/var/lib/mysql"
        read_only   = false
      }

      env = {
        DB_SERVER="mariadb-server.service.dc1.consul"
        DB_USER="root"
        DB_PASS="rootroot"
        DB_DUMP_TARGET="/var/lib/mysql"
      }

      config {
        image = "databack/mysql-backup"
      }

      resources {
        cpu    = 10
        memory = 256
      }
    }

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "db" {
        static = 3306
      }
    }
  }
}
