provider "digitalocean" {}

locals {
  name        = "app"
  environment = "test"
}

##------------------------------------------------
## Firewall module call
##------------------------------------------------
module "firewall" {
  source        = "./../../"
  name          = local.name
  environment   = local.environment
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [22, 80]
  #  droplet_ids     = "" #### Add droplet ids
}
