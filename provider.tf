# Register the DO token
variable "do_token" {
  type        = string
  description = "Digital Ocean token."
}

# Configure the DigitalOcean Provider
provider "digitalocean" {
  token = var.do_token
}
