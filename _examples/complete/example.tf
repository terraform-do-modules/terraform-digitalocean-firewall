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
  ssh_key            = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCbnaeXI+pAfwoMBLDl2r+fsRrBoqgRY54gcAawz0XJOiG6esHa13r28GGuEyAm5UGhDkVm6PZ8JAmLNpe8BTjJzF3BEZb+MMf0YLG+Gz6V5uyz9efuKxZqNTk2El36y5Z2dDUyrcT6FdayhRGtJPfUJc22tgucaTwA0I41SVJDb6OPeSYFalWIHk953RePWnJAjpRKyRqjnkbn6VUCqVQSNdJ+C4Qs7Zydullusm45UOMjhi20dgttdnnz6y9AOJDLws5IVmiee+Qwt1jO86RYSGyN2ikJQa6zB7Si1b8hlrVvDkBVGSxKs2mMJuLjXSx/SqdcwW17CDZLQoJ03WJgW3vs2sriyrtsFxWHCjssidl0sF83qVvUEsJKyNo7A6cXTAC++n2HlmWiDFpAns7qCrMkBJPOIT3hKDROozU+sLH8AL/mNd4yGpdTKDQGf+nDWq/5EGkHO4aq9RW9gQbGCX6H/zQTYudaDKLoVGf5LkYWtOC8+wfWmf2/dUA1KDU= devops"
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
