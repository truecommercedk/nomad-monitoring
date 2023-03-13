job "Alertmanager" {
  datacenters = ["dc1"]
  type        = "service"

  group "alertmanager" {
    count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 9093
      }
    }

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    volume "alertconfig" {
      type      = "host"
      read_only = false
      source    = "alertmanager_nfs"
    }


    task "alertmanager" {
      driver = "docker"
      user = "root"

      volume_mount {
        volume      = "alertconfig"
        destination = "/etc/alertmanager"
        read_only   = false
      }

      config {
        image = "prom/alertmanager:v0.25.0"
        args = [
          "--config.file=/local/alertmanager.conf",
          "--web.external-url=https://alertmanager.b2bi.dk",
          "--storage.path=/etc/alertmanager"
        ]
        ports = ["http"]
      }

      template {
        data        = <<EOTC
global:
  pagerduty_url: 'https://events.pagerduty.com/v2/enqueue'
  smtp_require_tls: false
  smtp_smarthost: 'smtp.b2bi.dk:25'
  smtp_from: 'alertmanager@truecommerce.com'

route:
  group_by: ['alertname']
  group_interval: 5s
  repeat_interval: 24h

  # A default receiver
  receiver: default

  routes:
  - matchers:
    - group= "dic"
    receiver: dic_alert

  - matchers:
    - severity= "information"
    receiver: information_alert

  - matchers:
    - severity= "critical"
    receiver: critical_alert

  - matchers:
    - severity= "netsuite"
    receiver:  netsuite_notify

  - matchers:
    - notify= "dev_support"
    receiver: devsupport_notify

  - matchers:
    - alertname = DeadMansSwitch
    receiver: dms
    group_wait: 0s
    group_interval: 15m
    repeat_interval: 5m

receivers:
- name: critical_alert
  pagerduty_configs:
   - send_resolved:  false
     routing_key: 8e2034cfb8b24105c0acc6d54d7d1a19

- name: dms
  webhook_configs:
   - url:  'https://nosnch.in/9bb83c6a13'
     send_resolved: false

- name: information_alert
  email_configs:
   - to: 'thomas.elsgaard@trucecommerce.com'

- name: devsupport_notify
  email_configs:
   - to: 'thomas.elsgaard@truecommerce.com'

- name: netsuite_notify
  email_configs:
   - to: 'SupportServices@truecommerce.com'

- name: dic_alert
  pagerduty_configs:
   - send_resolved:  false
     routing_key: "b86cc4fa6cf54808c0958eed68db421b"

- name: default
EOTC
        destination = "/local/alertmanager.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      resources {
        cpu    = 100
        memory = 100
      }

      service {
        name = "alertmanager"
        port = "http"
        tags = ["monitoring","prometheus"]

        check {
          name     = "Alertmanager HTTP"
          type     = "http"
          path     = "/#/status"
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