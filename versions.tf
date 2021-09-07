terraform {
  backend "remote" {
        // Backend configuration
  }
  required_providers {
    digitalocean = {
      source  = "digitalocean/digitalocean"
      version = "~> 1.22.1"
    }
  }
}

variable "do_token" {}

provider "digitalocean" {
  token = var.do_token
}
