job "Prometheus" {
  datacenters = ["dc1"]
  type        = "service"

  group "prometheus" {
    count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 9090
      }
    }

    volume "promconfig" {
      type      = "host"
      read_only = false
      source    = "prometheus_nfs"
    }

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    task "prometheus" {
      driver = "docker"
      user = "root"

      volume_mount {
        volume      = "promconfig"
        destination = "/var/lib/prometheus"
        read_only   = false
      }

      template {
        data        = <<EOTC
global:
  scrape_interval:     60s
  evaluation_interval: 60s

alerting:
  alertmanagers:
    - static_configs:
      - targets:
        - alertmanager.service.dc1.consul:9093

rule_files:
  - /local/prometheus/rules/*.rules.yml

scrape_configs:
  - job_name: 'prod'
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/prod-servers.yml
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'test'
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/test-servers.yml
    relabel_configs:
      - target_label: env
        replacement: test

  - job_name: 'demo'
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/demo-servers.yml
    relabel_configs:
      - target_label: env
        replacement: demo

  - job_name: 'netalogue'
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/netalogue.yml
    relabel_configs:
      - target_label: env
        replacement: netalogue

  - job_name: 'dic'
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/dic-servers.yml
    relabel_configs:
      - target_label: env
        replacement: dic

  - job_name: 'multitoolexporter'
    static_configs:
      - targets: ['multitoolexporter.service.dc1.consul:9141']
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'pagerdutyexporter'
    scrape_interval: 300s
    static_configs:
      - targets: ['pagerdutyexporter.service.dc1.consul:9143']
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'filestatusexporter'
    static_configs:
      - targets: ['filestatusexporter.service.dc1.consul:9144']
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'dotnetexporter'
    static_configs:
      - targets: ['dotnetexporter.service.dc1.consul:9142']
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'gen-dat-esw'
    static_configs:
      - targets: [ 'gen-dat-esw-001.tsprod.lan:9114' ]
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'gen-dat-adm'
    static_configs:
      - targets: [ 'adm-es-001.valhal.lan:9114' ]
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'vcenter'
    static_configs:
      - targets: [ 'vcenterexporter.service.dc1.consul:9272' ]
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'core-server-mgmt'
    metrics_path: /probe
    params:
      module: [http_2xx]
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/core-server-mgmt.yml
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackboxexporter.service.dc1.consul:9115
      - target_label: env
        replacement: production

  - job_name: 'http-responds'
    metrics_path: /probe
    params:
      module: [http_2xx]
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/http-responds.yml
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackboxexporter.service.dc1.consul:9115
      - target_label: env
        replacement: production

  - job_name: 'sharedservice-sor'
    metrics_path: /probe
    params:
      module: [http_2xx]
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/sharedservice-sor.yml
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackboxexporter.service.dc1.consul:9115
      - target_label: env
        replacement: production

  - job_name: 'sharedservice-dispatch'
    metrics_path: /probe
    params:
      module: [http_2xx]
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/sharedservice-dispatch.yml
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackboxexporter.service.dc1.consul:9115
      - target_label: env
        replacement: production

  - job_name: 'vlprx-responds'
    metrics_path: /probe
    params:
      module: [tcp_connect]
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/vlprx-responds.yml
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackboxexporter.service.dc1.consul:9115
      - target_label: env
        replacement: production

  - job_name: 'smtp-responds'
    metrics_path: /probe
    params:
      module: [tcp_connect]
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/smtp-responds.yml
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackboxexporter.service.dc1.consul:9115
      - target_label: env
        replacement: production

  - job_name: 'netsuite-responds'
    metrics_path: /probe
    params:
      module: [tcp_connect]
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/netsuite-responds.yml
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackboxexporter.service.dc1.consul:9115
      - target_label: env
        replacement: production

  - job_name: 'git-responds'
    metrics_path: /probe
    params:
      module: [tcp_connect]
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/git-responds.yml
    relabel_configs:
      - source_labels: [__address__]
        target_label: __param_target
      - source_labels: [__param_target]
        target_label: instance
      - target_label: __address__
        replacement: blackboxexporter.service.dc1.consul:9115
      - target_label: env
        replacement: production

  - job_name: 'farmer'
    scheme: https
    static_configs:
      - targets: ['farmer.b2bi.dk']
    tls_config:
      insecure_skip_verify: true
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'rabbitmq'
    metrics_path: /metrics/per-object
    metric_relabel_configs:
      - regex: 'channel'
        action: labeldrop
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/rabbitmq.yml
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'rabbitmqtest'
    metrics_path: /metrics/per-object
    metric_relabel_configs:
      - regex: 'channel'
        action: labeldrop
    file_sd_configs:
       - files:
          - /var/lib/prometheus/hosts/rabbitmq_test.yml
    relabel_configs:
      - target_label: env
        replacement: test

  - job_name: 'postfix'
    file_sd_configs:
      - files:
          - /var/lib/prometheus/hosts/postfix.yml
    relabel_configs:
      - target_label: env
        replacement: production

  - job_name: 'harvest'
    static_configs:
      - targets: ['harvester1.service.dc1.consul:12990']
      - targets: ['harvester2.service.dc1.consul:12991']
      - targets: ['harvester3.service.dc1.consul:12992']
      - targets: ['harvester4.service.dc1.consul:12993']
      - targets: ['harvester5.service.dc1.consul:12994']
      - targets: ['harvester6.service.dc1.consul:12995']
    relabel_configs:
      - target_label: env
        replacement: production
EOTC
        destination = "/local/prometheus.yml"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      config {
        image = "prom/prometheus:v2.41.0"
        ports = ["http"]
        args = [
          "--config.file=/local/prometheus.yml",
          "--storage.tsdb.path=/var/lib/prometheus/data",
          "--web.enable-admin-api",
          "--web.enable-lifecycle",
          "--storage.tsdb.retention.size=50GB"
        ]
      }
	  
	  artifact {
        source      = "github.com/truecommercedk/nomad-monitoring/prometheus"
        destination = "local/prometheus/"
      }

      resources {
        cpu    = 1000
        memory = 10240
      }

      service {
        name = "prometheus"
        port = "http"
        tags = ["monitoring","prometheus"]

        check {
          name     = "Prometheus HTTP"
          type     = "http"
          path     = "/targets"
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