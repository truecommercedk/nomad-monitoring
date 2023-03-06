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


#################
# Register jobs #
#################
resource "nomad_job" "prometheus" {
  jobspec = data.template_file.prometheus.rendered

}

resource "nomad_job" "harvester" {
  jobspec = data.template_file.harvester.rendered
}

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