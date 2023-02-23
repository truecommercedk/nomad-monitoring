job "dotnetexporter" {
  datacenters = ["dc1"]

  group "exporter" {
       count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 9142
      }
    }
	
	restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }
	
	task "dotnetexporterserver" {
      driver = "docker"

      config {
        image = "truecommercedk/dotnet_exporter:v0.0.11"
		volumes = [
          "local/dotnet_config.yml:/app/dotnet_config.yml",
        ]
		ports = ["http"]
      }
	  
      template {
        data = <<EOF
counters:
  - queue: bcprocessorerrorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: bcprocessorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: businessconfigurationprocessorerrorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: businessconfigurationprocessorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: databaseoperationerrorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: databaseoperationqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: elasticsearchcommanderrorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: elasticsearchcommandqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: messagebuserrorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: messagebusqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: TLAnalyzerCruncherErrorQueue
    host: gen-log-crw-001.tsprod.lan

  - queue: TLIncomingGWCruncherErrorQueue
    host: gen-log-crw-001.tsprod.lan

  - queue: TLOutgoingGWCruncherErrorQueue
    host: gen-log-crw-001.tsprod.lan

  - queue: TLProcEngCruncherErrorQueue
    host: gen-log-crw-001.tsprod.lan

  - queue: TLRouterCruncherErrorQueue
    host: gen-log-crw-001.tsprod.lan

  - queue: TLSplitterCruncherErrorQueue
    host: gen-log-crw-001.tsprod.lan

  - queue: TLValidatorCruncherErrorQueue
    host: gen-log-crw-001.tsprod.lan

  - queue: clientmessagebuserrorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: clientmessagebusqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: clientmessagebustransactionalqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: amqplogeventqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: clienteventlogerrorqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: clienteventlogqueue
    host: gen-bat-cmd-001.tsprod.lan

  - queue: amqplogeventqueuedoclog2
    host: gen-log-crw-001.tsprod.lan

  - queue: amqplogeventqueuedoclog
    host: gen-log-crw-001.tsprod.lan

  - queue: incominggwtransactionlogerrorqueue
    host: gen-log-crw-001.tsprod.lan

  - queue: amqplogeventqueuetranslog
    host: gen-log-crw-001.tsprod.lan

  - queue: amqplogeventqueuevltin
    host: gen-log-crw-001.tsprod.lan

  - queue: amqplogeventqueuevltout
    host: gen-log-crw-001.tsprod.lan

  - queue: clienteventlogerrorqueue
    host: gen-log-crw-001.tsprod.lan

  - queue: clienteventlogqueue
    host: gen-log-crw-001.tsprod.lan

  - queue: amqplogeventqueue
    host: dis-com-ext-001.tsprod.lan

  - queue: clienteventlogerrorqueue
    host: dis-com-ext-001.tsprod.lan

  - queue: clienteventlogqueue
    host: dis-com-ext-001.tsprod.lan

  - queue: clientmessagebuserrorqueue
    host: gen-web-int-001.tsprod.lan

  - queue: clientmessagebusqueue
    host: gen-web-int-001.tsprod.lan

  - queue: clientmessagebustransactionalqueue
    host: gen-web-int-001.tsprod.lan

  - queue: amqplogeventqueue
    host: gen-web-int-001.tsprod.lan

  - queue: clienteventlogerrorqueue
    host: gen-web-int-001.tsprod.lan

  - queue: clienteventlogqueue
    host: gen-web-int-001.tsprod.lan

  - queue: amqplogeventqueue
    host: oio-web-ext-001.tsprod.lan

  - queue: clienteventlogerrorqueue
    host: oio-web-ext-001.tsprod.lan

  - queue: clienteventlogqueue
    host: oio-web-ext-001.tsprod.lan

  - queue: amqplogeventqueue
    host: oio-web-ext-002.tsprod.lan

  - queue: clienteventlogerrorqueue
    host: oio-web-ext-002.tsprod.lan

  - queue: clienteventlogqueue
    host: oio-web-ext-002.tsprod.lan

  - queue: amqplogeventqueue
    host: oio-web-ext-003.tsprod.lan

  - queue: clienteventlogerrorqueue
    host: oio-web-ext-003.tsprod.lan

  - queue: clienteventlogqueue
    host: oio-web-ext-003.tsprod.lan

  - queue: amqplogeventqueue
    host: oio-web-ext-004.tsprod.lan

  - queue: clienteventlogerrorqueue
    host: oio-web-ext-004.tsprod.lan

  - queue: clienteventlogqueue
    host: oio-web-ext-004.tsprod.lan
EOF

        destination   = "local/dotnet_config.yml"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }
	  	  
	  resources {
        cpu    = 10 # MHz
        memory = 32 # MB
      }
	  
	  service {
        name = "dotnetexporter"
        port = "http"
        tags = ["exporter","monitoring","prometheus"]

		check {
          name     = "Exporter HTTP"
          type     = "http"
          path     = "/"
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
