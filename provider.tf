# Register the DO token
variable "do_token" {
  type        = string
  description = "DigitalOcean token."
}

terraform {
  required_version = ">= 0.13"
  required_providers {
    digitalocean = {
      source = "digitalocean/digitalocean"
    }
    time = {
      source = "hashicorp/time"
    }
  }
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}
