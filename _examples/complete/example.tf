provider "digitalocean" {
  #  token = ""
}

##------------------------------------------------
## VPC module call
##------------------------------------------------
module "vpc" {
  source      = "git::https://github.com/terraform-do-modules/terraform-digitalocean-vpc.git?ref=internal-423"
  name        = "app"
  environment = "test"
  region      = "blr1"
  ip_range    = "10.10.0.0/16"
}

##------------------------------------------------
## Droplet module call
##------------------------------------------------
module "droplet" {
  source             = "git::https://github.com/terraform-do-modules/terraform-digitalocean-droplet.git?ref=internal-425"
  name               = "app"
  environment        = "test"
  droplet_count      = 1
  region             = "blr1"
  vpc_uuid           = module.vpc.id
  droplet_size       = "s-1vcpu-1gb"
  image_name         = "ubuntu-18-04-x64"
  ssh_key            = "ssh-rsaEl36y5Z2dDUyrcT6FdayhRGtJPfUJc22tgu= test"
  monitoring         = false
  ipv6               = false
  floating_ip        = true
  block_storage_size = 5
  user_data          = file("user-data.sh")

  ####firewall
  allowed_ip    = ["10.10.0.0/16"]
  allowed_ports = [22, 80]
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
  droplet_ids   = module.droplet.id
}
