# Architecture: terraform-digitalocean-firewall

## Overview

This module manages DigitalOcean Cloud Firewalls and DigitalOcean Database Firewalls. It exposes a unified interface for attaching stateful firewall rules to droplets, Kubernetes clusters, and load balancers, as well as for restricting access to managed database clusters. The active resource type is selected automatically based on whether `database_cluster_id` is set.

## Cloud Firewall vs Droplet-Level Firewall

DigitalOcean provides two complementary firewall mechanisms:

| Attribute | Cloud Firewall (this module) | Droplet-level (ufw / iptables) |
|-----------|------------------------------|--------------------------------|
| Managed by | DigitalOcean control plane | Operating system inside droplet |
| Stateful | Yes | Depends on implementation |
| Applies before traffic reaches instance | Yes | No — traffic arrives first |
| Scope | Multiple droplets, tags, or Kubernetes clusters | Single instance only |
| Zero-downtime rule changes | Yes | Requires in-guest changes |

Cloud Firewalls are enforced at the hypervisor level and drop disallowed packets before they are delivered to the droplet. They are preferred over OS-level firewalls for shared infrastructure.

## Inbound Rules

Inbound rules are generated dynamically from `allowed_ports` and `allowed_ip`. Each port in `allowed_ports` produces one inbound rule using the `protocol` variable (default `tcp`). The same `allowed_ip` CIDR list applies as the source for every rule.

Additional sources per rule:

- `source_droplet_ids` — allow traffic from specific droplets
- `source_load_balancer_uids` — allow traffic from load balancers
- `source_kubernetes_ids` — allow traffic from Kubernetes clusters
- `source_tags` — allow traffic from droplets carrying specific tags

## Outbound Rules

Outbound rules are defined via `outbound_rule`, which accepts a list of objects. The default configuration allows all TCP and UDP egress to `0.0.0.0/0` and `::/0` across the full port range (1–65535). For production environments, restrict this to known destination CIDRs and required ports.

Each outbound rule object requires:

| Field | Description |
|-------|-------------|
| `protocol` | `tcp`, `udp`, `icmp`, or `all` |
| `port_range` | Port or range, e.g. `443` or `1-65535` |
| `destination_addresses` | List of destination CIDR blocks |

## Attaching Firewalls to Droplets

Pass droplet IDs to the `droplet_ids` variable. The firewall applies to all listed droplets immediately. To attach to Kubernetes node pools, pass the cluster ID via `kubernetes_ids`. To attach to load balancers, use `load_balancer_uids`.

```hcl
module "firewall" {
  source        = "terraform-do-modules/firewall/digitalocean"
  version       = "1.0.0"
  name          = "app"
  environment   = "prod"
  allowed_ip    = ["10.10.0.0/16"]
  allowed_ports = [22, 80, 443]
  droplet_ids   = module.droplet.id
}
```

## Tagging-Based Firewall Rules

DigitalOcean Cloud Firewalls support tag-based membership. Setting `tags` on the firewall resource causes it to apply to all droplets that carry those tags, without enumerating individual droplet IDs. This is useful for auto-scaled groups where droplet IDs change frequently.

```hcl
module "firewall" {
  source        = "terraform-do-modules/firewall/digitalocean"
  version       = "1.0.0"
  name          = "web"
  environment   = "prod"
  allowed_ip    = ["0.0.0.0/0"]
  allowed_ports = [80, 443]
  tags          = ["web-tier"]
}
```

## Database Firewall

When `database_cluster_id` is set, this module creates a `digitalocean_database_firewall` resource instead of a `digitalocean_firewall`. Database firewall rules use a `type`/`value` pair model and support IP address (`ip_addr`), Droplet (`droplet`), Kubernetes (`k8s`), and tag-based rules.

```hcl
module "firewall" {
  source              = "terraform-do-modules/firewall/digitalocean"
  version             = "1.0.0"
  name                = "db"
  environment         = "prod"
  database_cluster_id = "<cluster-id>"
  rules = [
    { type = "ip_addr", value = "10.10.0.5" },
    { type = "droplet", value = "<droplet-id>" },
  ]
}
```

Only one of `digitalocean_firewall` or `digitalocean_database_firewall` is created per module invocation. They cannot be combined in a single call.

## Operational Checklist

- Restrict `allowed_ip` to the minimum required source CIDRs; avoid `0.0.0.0/0` on port 22 in production.
- Use separate module invocations for application firewalls and database firewalls.
- Tighten outbound rules in environments requiring egress control (e.g., PCI DSS, SOC 2).
- Apply consistent tags to droplets and reference them in firewall rules for dynamic membership rather than hard-coding droplet IDs.
- When attaching to Kubernetes clusters, use `kubernetes_ids`, not `droplet_ids`, so that node pool replacements do not break firewall membership.
- Set `enabled = false` to disable all resource creation without removing the module block.
- Verify outbound rules do not inadvertently allow all egress (`1-65535` to `0.0.0.0/0`) in regulated environments.
