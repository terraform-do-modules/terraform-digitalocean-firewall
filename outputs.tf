# ------------------------------------------------------------------------------
# Outputs
# ------------------------------------------------------------------------------
output "id" {
  value       = digitalocean_firewall.default[*].id
  description = "A unique ID that can be used to identify and reference a Firewall."
}
output "name" {
  value       = digitalocean_firewall.default[*].name
  description = "The name of the Firewall."
}
output "droplet_ids" {
  value       = digitalocean_firewall.default[*].droplet_ids
  description = "The list of the IDs of the Droplets assigned to the Firewall."
}
output "inbound_rule" {
  value       = digitalocean_firewall.default[*].inbound_rule
  description = "The inbound access rule block for the Firewall."
}
output "outbound_rule" {
  value       = digitalocean_firewall.default[*].outbound_rule
  description = "The name of the Firewall."
}
output "database_uuid" {
  value       = digitalocean_database_firewall.default[*].id
  description = "A unique identifier for the firewall rule."
}
output "cluster_id" {
  value       = digitalocean_database_firewall.default[*].cluster_id
  description = "The ID of the target database cluster."
}