# Configure the Nomad provider
provider "nomad" {
  address = "http://10.15.91.225:4646"
}


data "template_file" "prometheus" {
  template = file("./templates/prometheus.nomad")
}

data "template_file" "harvester" {
  template = file("./templates/harvester.nomad")
}

#data "template_file" "mimir1" {
#  template = file("./templates/mimir-1.nomad")
#}

#data "template_file" "mimir2" {
#  template = file("./templates/mimir-2.nomad")
#}

#data "template_file" "mimir3" {
#  template = file("./templates/mimir-3.nomad")
#}

data "template_file" "grafana" {
  template = file("./templates/grafana.nomad")
}

data "template_file" "alertmanager" {
  template = file("./templates/alertmanager.nomad")
}

data "template_file" "multitoolexporter" {
  template = file("./templates/multitoolexporter.nomad")
}

data "template_file" "dotnetexporter" {
  template = file("./templates/dotnetexporter.nomad")
}

data "template_file" "filestatusexporter" {
  template = file("./templates/filestatusexporter.nomad")
}

data "template_file" "vcenterexporter" {
  template = file("./templates/vcenterexporter.nomad")
}

data "template_file" "pdexporter" {
  template = file("./templates/pdexporter.nomad")
}

#data "template_file" "esadm" {
#  template = file("./templates/es_adm.nomad")
#}

#data "template_file" "esesw" {
#  template = file("./templates/es_esw.nomad")
#}

data "template_file" "blackboxexporter" {
  template = file("./templates/blackboxexporter.nomad")
}

data "template_file" "mariadb" {
  template = file("./templates/mariadb.nomad")
}

data "template_file" "farmer" {
  template = file("./templates/farmer.nomad")
}

data "template_file" "msdp" {
  template = file("./templates/msdp.nomad")
}

data "template_file" "nginx-farmer" {
  template = file("./templates/nginx-farmer.nomad")
}

data "template_file" "nginx-msdp" {
  template = file("./templates/nginx-msdp.nomad")
}

#data "template_file" "nginx-mimir" {
#  template = file("./templates/nginx-mimir.nomad")
#}

#################
# Register jobs #
#################
resource "nomad_job" "prometheus" {
  jobspec = data.template_file.prometheus.rendered

}

resource "nomad_job" "harvester" {
  jobspec = data.template_file.harvester.rendered
}

#resource "nomad_job" "mimir1" {
#  jobspec = data.template_file.mimir1.rendered
#}

#resource "nomad_job" "mimir2" {
#  jobspec = data.template_file.mimir2.rendered
#}

#resource "nomad_job" "mimir3" {
#  jobspec = data.template_file.mimir3.rendered
#}

resource "nomad_job" "alertmanager" {
  jobspec = data.template_file.alertmanager.rendered

}

resource "nomad_job" "grafana" {
  jobspec = data.template_file.grafana.rendered
}

resource "nomad_job" "multitoolexporter" {
  jobspec = data.template_file.multitoolexporter.rendered
}

resource "nomad_job" "dotnetexporter" {
  jobspec = data.template_file.dotnetexporter.rendered
}


resource "nomad_job" "filestatusexporter" {
  jobspec = data.template_file.filestatusexporter.rendered
}

resource "nomad_job" "vcenterexporter" {
  jobspec = data.template_file.vcenterexporter.rendered
}

resource "nomad_job" "pdexporter" {
  jobspec = data.template_file.pdexporter.rendered
}

#resource "nomad_job" "esadm" {
#  jobspec = data.template_file.esadm.rendered
#}

#resource "nomad_job" "esesw" {
#  jobspec = data.template_file.esesw.rendered
#}

resource "nomad_job" "blackboxexporter" {
  jobspec = data.template_file.blackboxexporter.rendered
}

resource "nomad_job" "mariadb" {
  jobspec = data.template_file.mariadb.rendered
}

resource "nomad_job" "farmer" {
  jobspec = data.template_file.farmer.rendered
}

resource "nomad_job" "msdp" {
  jobspec = data.template_file.msdp.rendered
}

resource "nomad_job" "nginx-farmer" {
  jobspec = data.template_file.nginx-farmer.rendered
}

resource "nomad_job" "nginx-msdp" {
  jobspec = data.template_file.nginx-msdp.rendered
}

#resource "nomad_job" "nginx-mimir" {
#  jobspec = data.template_file.nginx-mimir.rendered
#}