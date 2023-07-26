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
  ##  we can use all them need to pass value accordingly for droplet , kubernetes and load balancer.
  //  droplet_ids        = []
  //  kubernetes_ids     = []
  //  load_balancer_uids = []
}
