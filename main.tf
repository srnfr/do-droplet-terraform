resource "digitalocean_tag" "sew" {
  name = "sew"
lifecycle {
        prevent_destroy = true
  }
}
resource "digitalocean_droplet" "docker" {
  image  = "docker-20-04"
  name   = "${var.prefix}-docker"
  region = var.region_name
  size   = var.droplet_size
  tags               = [digitalocean_tag.docker.id]
  monitoring         = "true"
  private_networking = "true"
  ssh_keys           = var.ssh_keys
}

resource "digitalocean_record" "docker" {
  domain = var.domain_name
  type   = "A"
  name   = "docker"
  value  = digitalocean_droplet.docker.ipv4_address
}
