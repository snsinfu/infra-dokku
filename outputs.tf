data "template_file" "ansible_inventory" {
  template = "${file("hosts.ini.in")}"

  vars {
    server_address = "${hcloud_server.dokku.ipv4_address}"
    ssh_port       = "${var.ssh_port}"
    admin_user     = "${var.admin_user}"
  }
}

output "ansible_inventory" {
  value = "${data.template_file.ansible_inventory.rendered}"
}

output "ip" {
  value = "${hcloud_server.dokku.ipv4_address}"
}
