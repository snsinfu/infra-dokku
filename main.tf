terraform {
  backend "gcs" {
    prefix = "dokku"
  }
}

resource "hcloud_server" "dokku" {
  name        = "dokku.${var.domain}"
  server_type = "${var.server_type}"
  image       = "${var.server_image}"
  location    = "${var.server_location}"
  ssh_keys    = ["${hcloud_ssh_key.primary.id}"]
  user_data   = "${data.template_file.cloudinit.rendered}"
}

resource "hcloud_ssh_key" "primary" {
  name       = "primary key"
  public_key = "${var.primary_pubkey}"
}

data "template_file" "cloudinit" {
  template = "${file("files/cloudinit.yml.in")}"
  vars {
    admin_user = "${var.admin_user}"
    ssh_port   = "${var.ssh_port}"
  }
}
