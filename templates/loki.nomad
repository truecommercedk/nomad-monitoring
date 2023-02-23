job "loki" {
  datacenters = ["dc1"]
  type        = "service"

  group "loki" {
    count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 3100
      }
    }

    volume "lokidata" {
      type      = "host"
      read_only = false
      source    = "loki_host"
    }

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    task "loki" {
      driver = "docker"
      user = "root"

      volume_mount {
        volume      = "lokidata"
        destination = "/tmp/loki"
        read_only   = false
      }

      template {
        data        = <<EOTC
auth_enabled: false

server:
  http_listen_port: 3100
  grpc_listen_port: 9096

ingester:
  wal:
    enabled: true
    dir: /tmp/wal
  lifecycler:
    address: 127.0.0.1
    ring:
      kvstore:
        store: inmemory
      replication_factor: 1
    final_sleep: 0s
  chunk_idle_period: 1h
  max_chunk_age: 1h
  chunk_target_size: 1048576
  chunk_retain_period: 30s
  max_transfer_retries: 0

schema_config:
  configs:
    - from: 2020-10-24
      store: boltdb-shipper
      object_store: filesystem
      schema: v11
      index:
        prefix: index_
        period: 24h

storage_config:
  boltdb_shipper:
    active_index_directory: /tmp/loki/boltdb-shipper-active
    cache_location: /tmp/loki/boltdb-shipper-cache
    cache_ttl: 24h
    shared_store: filesystem
  filesystem:
    directory: /tmp/loki/chunks

compactor:
  working_directory: /tmp/loki/boltdb-shipper-compactor
  shared_store: filesystem

limits_config:
  reject_old_samples: true
  reject_old_samples_max_age: 168h

chunk_store_config:
  max_look_back_period: 0s

table_manager:
  retention_deletes_enabled: false
  retention_period: 0s

query_scheduler:
  max_outstanding_requests_per_tenant: 10000

ruler:
  storage:
    type: local
    local:
      directory: /tmp/loki/rules
  rule_path: /loki/rules-temp
  alertmanager_url: http://alertmanager.service.dc1.consul:9093
  ring:
    kvstore:
      store: inmemory
  enable_api: true
EOTC
        destination = "/local/loki-config.yaml"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

#      env {
#        JAEGER_AGENT_HOST    = "tempo.service.dc1.consul"
#        JAEGER_TAGS          = "cluster=nomad"
#        JAEGER_SAMPLER_TYPE  = "probabilistic"
#        JAEGER_SAMPLER_PARAM = "1"
#      }

      config {
        image = "grafana/loki:latest"
        ports = ["http"]
        args = [
          "-config.file=/local/loki-config.yaml",
        ]
      }

      resources {
        cpu    = 200
        memory = 200
      }

      service {
        name = "loki"
        port = "http"
        tags = ["monitoring","prometheus"]

        check {
          name     = "Loki HTTP"
          type     = "http"
          path     = "/ready"
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