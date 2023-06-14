provider "digitalocean" {
  #  token = ""
}

##------------------------------------------------
## Firewall module call
##------------------------------------------------
module "firewall" {
  source        = "./../../"
  name          = "app"
  environment   = "test"
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [22, 80]
  #  droplet_ids     = "" #### Add droplet ids
}
