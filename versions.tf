terraform {
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 1.22.1"
    }
  }
}

provider "digitalocean" {
  token = var.do_token
}
