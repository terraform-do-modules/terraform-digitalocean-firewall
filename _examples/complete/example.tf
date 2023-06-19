provider "digitalocean" {}

locals {
  name        = "app"
  environment = "test"
  region      = "blr1"
}

##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "git::https://github.com/terraform-do-modules/terraform-digitalocean-vpc.git?ref=internal-423"
  name        = local.name
  environment = local.environment
  region      = local.region
  ip_range    = "10.10.0.0/16"
}

##------------------------------------------------
## Droplet module call
##------------------------------------------------
module "droplet" {
  source      = "git::https://github.com/terraform-do-modules/terraform-digitalocean-droplet.git?ref=internal-425"
  name        = local.name
  environment = local.environment
  region      = local.region
  vpc_uuid    = module.vpc.id
  ssh_key     = "ssh-rsaEl36y5Z2dDUyrcT6FdayhRGtJPfUJfc22tgu= test"
  user_data   = file("user-data.sh")
  ####firewall
  inbound_rules = [
    {
      allowed_ip    = ["10.10.0.0/16"]
      allowed_ports = "22"
    },
  ]
}

##------------------------------------------------
## Firewall module call
##------------------------------------------------
module "firewall" {
  source        = "./../../"
  name          = local.name
  environment   = local.environment
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
  droplet_ids   = module.droplet.id
}