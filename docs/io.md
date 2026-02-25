# Inputs and Outputs: terraform-digitalocean-firewall

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|----------|
| `name` | Name (e.g. `app` or `cluster`). | `string` | `""` | no |
| `environment` | Environment (e.g. `prod`, `dev`, `staging`). | `string` | `""` | no |
| `label_order` | Label order, e.g. `name`, `application`. | `list(any)` | `["name", "environment"]` | no |
| `managedby` | ManagedBy, eg `terraform-do-modules` or `hello@clouddrove.com`. | `string` | `"terraform-do-modules"` | no |
| `enabled` | Flag to control the firewall creation. | `bool` | `true` | no |
| `allowed_ip` | List of allowed IP source CIDRs for inbound rules. | `list(any)` | `[]` | no |
| `allowed_ports` | List of allowed ingress ports. | `list(any)` | `[]` | no |
| `protocol` | The protocol for inbound rules. Accepts `tcp`, `udp`, `icmp`, or `all`. | `string` | `"tcp"` | no |
| `droplet_ids` | List of Droplet IDs to attach the firewall to. | `list(any)` | `[]` | no |
| `load_balancer_uids` | List of load balancer UIDs to include as inbound/outbound targets. | `list(any)` | `[]` | no |
| `kubernetes_ids` | List of Kubernetes cluster IDs to include as inbound/outbound targets. | `list(any)` | `[]` | no |
| `tags` | Array of tag names corresponding to groups of Droplets from which inbound traffic will be accepted. | `list(any)` | `[]` | no |
| `database_cluster_id` | The ID of the target database cluster. When set, a database firewall is created instead of a cloud firewall. | `string` | `null` | no |
| `rules` | List of objects representing database firewall rules (used when `database_cluster_id` is set). Each object requires `type` and `value`. | `any` | `[]` | no |
| `outbound_rule` | List of outbound rule objects. Each object requires `protocol`, `port_range`, and `destination_addresses`. | `list(object({ protocol = string, port_range = string, destination_addresses = list(string) }))` | Allow all TCP and UDP egress to `0.0.0.0/0` and `::/0` | no |

## Outputs

| Name | Description |
|------|-------------|
| `id` | A unique ID that can be used to identify and reference a Firewall. |
| `name` | The name of the Firewall. |
| `droplet_ids` | The list of the IDs of the Droplets assigned to the Firewall. |
| `inbound_rule` | The inbound access rule block for the Firewall. |
| `outbound_rule` | The outbound access rule block for the Firewall. |
| `database_uuid` | A unique identifier for the database firewall rule. |
| `cluster_id` | The ID of the target database cluster (populated when a database firewall is created). |
