##-----------------------------------------------------------------------------
## Labels module callled that will be used for naming and tags.
##-----------------------------------------------------------------------------
module "labels" {
  source      = "git::https://github.com/terraform-do-modules/terraform-digitalocean-labels.git?ref=internal-426m"
  name        = var.name
  environment = var.environment
  managedby   = var.managedby
  label_order = var.label_order
}

##-------------------------------------------------------------------------------------------------------------------------
#Description :  Provides a DigitalOcean Cloud Firewall resource. This can be used to create, modify, and delete Firewalls.
##-------------------------------------------------------------------------------------------------------------------------

#tfsec:ignore:digitalocean-compute-no-public-ingress   ## because by default we use ["0.0.0.0/0"], do not use on prod env.
#tfsec:ignore:digitalocean-compute-no-public-egress    ## The port is exposed for ingress from the internet, by default we use  ["0.0.0.0/0", "::/0"].
resource "digitalocean_firewall" "default" {
  count       = var.enabled == true ? 1 : 0
  name        = format("%s-firewall", module.labels.id)
  droplet_ids = var.droplet_ids
  dynamic "inbound_rule" {
    iterator = port
    for_each = var.allowed_ports
    content {
      port_range                = port.value
      protocol                  = var.protocol
      source_addresses          = var.allowed_ip
      source_droplet_ids        = var.droplet_ids
      source_load_balancer_uids = var.load_balancer_uids
      source_kubernetes_ids     = var.kubernetes_ids
      source_tags               = var.tags
    }
  }

  outbound_rule {
    protocol                       = "tcp"
    port_range                     = "1-65535"
    destination_addresses          = ["0.0.0.0/0", "::/0"]
    destination_droplet_ids        = var.droplet_ids
    destination_kubernetes_ids     = var.kubernetes_ids
    destination_load_balancer_uids = var.load_balancer_uids
    destination_tags               = var.tags
  }

  outbound_rule {
    protocol                       = "udp"
    port_range                     = "1-65535"
    destination_addresses          = ["0.0.0.0/0", "::/0"]
    destination_droplet_ids        = var.droplet_ids
    destination_kubernetes_ids     = var.kubernetes_ids
    destination_load_balancer_uids = var.load_balancer_uids
    destination_tags               = var.tags
  }

  tags = [
    module.labels.name,
    module.labels.environment,
    module.labels.managedby
  ]
}

##------------------------------------------------------------------------------------------------------------------------------------------
#Description : Provides a DigitalOcean database firewall resource allowing you to restrict connections to your database to trusted sources.
##------------------------------------------------------------------------------------------------------------------------------------------
resource "digitalocean_database_firewall" "default" {
  count = var.enabled == true && var.database_cluster_id != null ? 1 : 0

  cluster_id = var.database_cluster_id

  dynamic "rule" {
    for_each = var.rules
    content {
      type  = rule.value.type
      value = rule.value.value
    }
  }
}