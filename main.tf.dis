variable "region_name" {
  type        = string
}
variable "domain_name" {
  type        = string
}
variable "droplet_size" {
  type        = string
}
variable "prefix" {
  type        = string
}

variable "tag_name" {
  type        = string
}

variable "ssh_keys" {
  default = []
}

resource "digitalocean_tag" "tag" {
  name = var.tag_name
  lifecycle {
    prevent_destroy = true
  }
}

resource "digitalocean_droplet" "docker" {
  image  = "docker-20-04"
  name   = "${var.prefix}-docker"
  region = var.region_name
  size   = var.droplet_size
  tags               = [digitalocean_tag.tag.id]
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
