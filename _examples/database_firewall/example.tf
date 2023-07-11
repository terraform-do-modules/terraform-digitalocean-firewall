provider "digitalocean" {}

locals {
  name        = "app"
  environment = "test"
}

##------------------------------------------------
## database Firewall module call
##------------------------------------------------
module "firewall" {
  source              = "./../../"
  name                = local.name
  environment         = local.environment
  database_cluster_id = "" ## add database cluster id
  rules = [
    {
      type  = "ip_addr"
      value = "192.168.1.1"
    },
  ]
}
