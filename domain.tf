resource "cloudflare_record" "dokku" {
  domain  = "${var.domain}"
  name    = "dokku"
  type    = "A"
  value   = "${hcloud_server.dokku.ipv4_address}"
  proxied = false
}

resource "cloudflare_record" "dokku_subdomains" {
  domain  = "${var.domain}"
  name    = "*.dokku"
  type    = "CNAME"
  value   = "dokku.${var.domain}"
  proxied = false
}
