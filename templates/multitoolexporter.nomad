job "multitoolexporter" {
  datacenters = ["dc1"]

  group "exporter" {
    count = 1

    network {
      dns {
        servers = ["10.15.91.234", "10.15.91.235", "10.15.91.228"]
      }
      port "http" {
        static = 9141
      }
    }

    restart {
      attempts = 3
      delay    = "20s"
      mode     = "delay"
    }

    task "MultiToolExporterServer" {
      driver = "docker"
      env {
        PORT = "$${NOMAD_PORT_http}"
      }

      config {
        image   = "truecommercedk/multitool_exporter:v0.0.32"
        volumes = [
          "local/multitool_config.yml:/app/multitool_config.yml",
        ]
        ports = ["http"]
      }

      template {
        data = <<EOTC
counters:
  - name: EB01 - Processing
    query: "Status=Processing and LatestReceiver=Eb01@eserver.dannet.dk Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: EB02 - Processing
    query: "Status=Processing and LatestReceiver=Eb02@eserver.dannet.dk Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: EB04 - Processing
    query: "Status=Processing and LatestReceiver=Eb04@eserver.dannet.dk Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: EB05 - Processing
    query: "Status=Processing and LatestReceiver=Eb05@eserver.dannet.dk Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: EB07 - Processing
    query: "Status=Processing and LatestReceiver=Eb07@eserver.dannet.dk Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Eserver - Processing
    query: "Status=Processing and LatestReceiver=Eserver@eserver.dannet.dk Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Log - Next record not merged
    query: "(NextMergeReady=true and SentTime>=-1hours and SentTime<=-30Minutes) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Log - Flows - Looping
    query: "(Status=Processing and ProcessingActions=Looping) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting positive control processing delivered mode
    query: "(PositiveControlStatus=ProcessingDeliveredMode and SentTime<-10minutes) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Log - Processing Engine - Failed orphan records
    query: "Status=Failed and MergeTried=true and Missing(TransactionLogDocumentId) and ProcessingEndTime<=-60minutes Size(0)"
    index: TransactionLogProcEngMonitoring
    lastDays: 30

  - name: OIOD01
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod1 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD02
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod2 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD03
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod3 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD04
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod4 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD05
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod5 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD06
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod6 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD07
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod7 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD08
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod8 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD09
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod9 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD10
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod10 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD11
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod11 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOD12
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oiod12 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOH01
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oioh1 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: OIOH02
    query: "OutgoingGW=oiosi and Status=Delivered and OutgoingGWInstance=Oioh2 and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Business Configuration - Control route conflict
    query: "EventName=ControlRouteConflict Size(0)"
    index: LoggingTraceMonitoring
    lastDays: 30

  - name: Business Configuration - Control route creation failed
    query: "EventName=ControlRouteCreationFailed Size(0)"
    index: LoggingTraceMonitoring
    lastDays: 30

  - name: Business Configuration - RouteAdm migration failed
    query: "EventName=RouteAdmMigrationFailed Size(0)"
    index: LoggingTraceMonitoring
    lastDays: 30

  - name: SOR Download did not run
    query: '{"track_total_hits": true, "query": {"bool":{ "must":[{"bool":{ "must":[{"term": {"component":{"value":"sordownloadbackgroundservices"}}},{"bool":{ "must":[{"term": {"eventName":{"value":"sordownloadsuccess"}}},{"range": {"@timestamp":{"gte":"now-24h"}}}]}}]}}]}},"from" : 0 ,"sort": [ {"@timestamp": {"order": "desc" }  }] ,"size" : 0 }'
    index: LoggingAll
    lastDays: 1

  - name: SOR Download failed
    query: '{"track_total_hits": true, "query": {"bool":{ "must":[{"bool":{ "must":[{"term": {"component":{"value":"sordownloadbackgroundservices"}}},{"bool":{ "must":[{"term": {"eventName":{"value":"sordownloadfailed"}}},{"range": {"@timestamp":{"gte":"now-24h"}}}]}}]}}]}},"from" : 0 ,"sort": [ {"@timestamp": {"order": "desc" }  }] ,"size" : 0 }'
    index: LoggingAll
    lastDays: 1

  - name: TIEKE - New qualifier encounted
    query: "EventName=NewTiekeQualifierEncountered Size(0)"
    index: LoggingSystemMonitoring
    lastDays: 30

  - name: TIEKE - New VANS encounted
    query: "EventName=NewTiekeVansEncountered Size(0)"
    index: LoggingSystemMonitoring
    lastDays: 30

  - name: TIEKE - XML Download
    query: "EventName=TiekeMasterDataDownloaded Size(0)"
    index: LoggingSystemMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting Error Processing
    query: "(Status=[Failed,ResendFailed,ReportingFailed] and ErrorTime<=-30minutes) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting positive control processing received mode
    query: "(PositiveControlStatus=ProcessingReceivedMode and SentTime<-10minutes) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting reporting - AppResp
    query: "(Status=QueuedForReporting and ReportType=ApplicationResponse and ReportingTime<=-1hours) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting reporting - Controls
    query: "(Status=QueuedForReporting and ReportType=NegativeControl and ReportingTime<=-1hours) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting reporting - Mail
    query: "(Status=QueuedForReporting and ReportType=MailToSender and ReportingTime<=-1hours) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting reporting - NetSuite
    query: "(Status=QueuedForReporting and ReportType=[NetSuiteCasePerSender,NetSuiteCase] and ReportingTime<=-1hours) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting reporting - OneTime Ack
    query: "(OneTimeAckStatus=Queued and SentTime<=-60minutes) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Awaiting Resending
    query: "(Status=Status=QueuedForResend and ResendTime<=-30minutes) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Billing Processor
    query: "receivedTime>now-10h Size(0)"
    index: TPBillingTranslog
    lastDays: 1

  - name: Transaction Processing - Negative control setup conflict
    query: "EventName=NegativeControlSetupConflict"
    index: LoggingTraceMonitoring
    lastDays: 30

  - name: Transaction Processing - NetSuite reporting failed
    query: "(Status=NetSuiteReportingFailed and SentTime<-30minutes) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Positive control lookup failure
    query: "(PositiveControlStatus=Failed) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Processing - Put On Hold
    query: "(Status=OnHold and SentTime<-4hours) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Log - Incoming GW - No FID
    query: "Status=Processsing and Missing(EarliestFileId) and ReceivedTime<=-30minutes Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Log - Incoming GW - OIOSI records
    query: "Component=oiosi and ProcessingEndTime>= -2hours Size(0)"
    index: TransactionLogIncomingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Incoming GW - VLTrader records
    query: "Component=VLTrader and ProcessingEndTime>= -1hours Size(0)"
    index: TransactionLogIncomingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Incoming GW - X400 records
    query: "Component=X400 and ProcessingEndTime>= -1hours Size(0)"
    index: TransactionLogIncomingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Incoming GW - Records not merged
    query: "MergeTried=false and ProcessingEndTime<=-30minutes Size(0)"
    index: TransactionLogIncomingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Outgoing GW - Failed orphan records
    query: "Status=Failed and MergeTried=true and Missing(TransactionLogDocumentId) and exists(fileId) and ProcessingEndTime<=-60minutes Size(0)"
    index: TransactionLogOutgoingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Outgoing GW - OIOSI records
    query: "Component=oiosi and ProcessingEndTime>= -1hours Size(0)"
    index: TransactionLogOutgoingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Outgoing GW - VLTrader records
    query: "Component=VLTrader and ProcessingEndTime>= -1hours Size(0)"
    index: TransactionLogOutgoingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Outgoing GW - X400 records
    query: "Component=X400 and ProcessingEndTime>= -1hours Size(0)"
    index: TransactionLogOutgoingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Outgoing GW - OIOSI in processing state
    query: "Status=Processing and OutgoingGW=oiosi and SentTime<=-30minutes Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Log - Outgoing GW - Records not merged
    query: "MergeTried=false and ProcessingEndTime<=-30minutes Size(0)"
    index: TransactionLogOutgoingGWMonitoring
    lastDays: 30

  - name: Transaction Log - Previous record not merged
    query: "(PrevMergeReady=true and SentTime<=-30minutes) and (OP5AlarmHandled<>true) or (fieldsdiff(oP5AlarmHandledResendCount, ResendCount) or missing(oP5AlarmHandledResendCount)) Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: Transaction Log - Processing Engine - ebroker records
    query: "Component=ebroker and ProcessingEndTime>= -1hours Size(0)"
    index: TransactionLogProcEngMonitoring
    lastDays: 30

  - name: Transaction Log - Processing Engine - Records not merged
    query: "MergeTried=false and ProcessingEndTime<=-30minutes Size(0)"
    index: TransactionLogProcEngMonitoring
    lastDays: 30

  - name: tpruleprocessor - ESException
    query: '{"track_total_hits": true, "query": {"bool":{ "must":[{"bool":{ "must":[{"term": {"component":{"value":"tpruleprocessor"}}},{"bool":{ "must":[{"term": {"eventName":{"value":"esexception"}}},{"range": {"@timestamp":{"gte":"now-2h"}}}]}}]}}]}},"from" : 0 ,"sort": [ {"@timestamp": {"order": "desc" }  }] ,"size" : 0 }'
    index: LoggingAll
    lastDays: 1

  - name: Problems - ebroker Response de-serialization failed
    query: "ErrorMessage=De-serialization and LatestComponent=eBroker and ErrorTime>=-4hours Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: MSPULL - In processing state
    query: "Status=Processing and LatestComponent=mspull and missing(LatestFileId) and ReceivedTime<=-30minutes Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: DBGW - Payload is missing
    query: '{"track_total_hits": true, "query": {"bool":{ "must":[{"bool":{ "must":[{"term": {"component":{"value":"dbgw"}}},{"bool":{ "must":[{"term": {"eventName":{"value":"dispatchfailedtemporarily"}}},{"bool":{ "must":[{"wildcard": {"message":{"value":"*payload is missing"}}},{"range": {"@timestamp":{"gt":"now-1d"}}}]}}]}}]}}]}},"from" : 0 ,"sort": [ {"@timestamp": {"order": "desc" }  }] ,"size" : 0 }'
    index: LoggingAll
    lastDays: 1

  - name: SOR Validation
    query: '{"track_total_hits": true, "query": {"bool":{ "must":[{"bool":{ "must":[{"term": {"guru_b2bi_actorComponent":{"value":"sordownloadbackgroundservices"}}},{"bool":{ "must":[{"term": {"eventName":{"value":"sor_tp_updates"}}},{"bool":{ "must":[{"bool":{"should":[{"wildcard": {"message":{"value":"*please investigate"}}},{"wildcard": {"message":{"value":"*manual inspection is required."}}}],"minimum_should_match":1}},{"range": {"@timestamp":{"gte":"now-13h"}}}]}}]}}]}}]}},"from" : 0 ,"sort": [ {"@timestamp": {"order": "desc" }  }] ,"size" : 0 }'
    index: LoggingAll
    lastDays: 1

  - name: KMD-OutgoingNonCritcalFile2h
    query: "OP5AlarmHandled<>true and ReceiverAgreementNumber=[910225] and status=ready and ( IncomingDocumentSupertype<>[orderresponse, orderchange, order, despatadvice] and OutgoingDocumentSupertype<>[orderresponse, orderchange, order, despatchadvice]) and SentTime>now-24h and SentTime<now-2h Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: KMD-OutgoingCRITICALFile1h
    query: "OP5AlarmHandled<>true and ReceiverAgreementNumber=[910225] and status=ready and (IncomingDocumentSupertype=[orderresponse, orderchange, order, despatadvice] or OutgoingDocumentSupertype=[orderresponse, orderchange, order, despatchadvice]) and SentTime<=-1hours Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30

  - name: FalabellaWS-SodimacWS_PROD
    query: "IncomingGWHost=[220082_FalabellaWS_PROD,220081_SodimacWS_PROD] and ErrorMessage=\"*Error Interno del Servidor*\" and Senttime > now-4h Size(0)"
    index: TransactionLogMonitoring
    lastDays: 1

  - name: DE-X400
    query: "EarliestSender=mailbox=99A888_AS2ID_X400-B2B&host=99A888_TC_DE_B2B_Clearing_AS2&flow=ms2cleo@dbgw5.dannet.dk and SentTime>now-1m Size(0)"
    index: TransactionLogMonitoring
    lastDays: 30
EOTC

        destination   = "local/multitool_config.yml"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      env {
        MT_HOST = "service.b2bi.dk"
      }

      resources {
        cpu    = 100 # MHz
        memory = 128 # MB
      }

      service {
        name = "multitoolexporter"
        port = "http"
        tags = ["exporter", "monitoring", "prometheus"]

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
