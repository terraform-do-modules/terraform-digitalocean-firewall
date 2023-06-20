output "uuid" {
  value       = module.firewall[*].database_uuid
  description = "A unique identifier for the firewall rule."
}
