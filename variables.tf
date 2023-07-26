#Module      : LABEL
#Description : Terraform label module variables.
variable "name" {
  type        = string
  default     = ""
  description = "Name  (e.g. `app` or `cluster`)."
}

variable "environment" {
  type        = string
  default     = ""
  description = "Environment (e.g. `prod`, `dev`, `staging`)."
}

variable "label_order" {
  type        = list(any)
  default     = ["name", "environment"]
  description = "Label order, e.g. `name`,`application`."
}

variable "managedby" {
  type        = string
  default     = "terraform-do-modules"
  description = "ManagedBy, eg 'terraform-do-modules' or 'hello@clouddrove.com'"
}

variable "enabled" {
  type        = bool
  default     = true
  description = "Flag to control the firewall creation."
}

variable "allowed_ip" {
  type        = list(any)
  default     = []
  description = "List of allowed ip."
}

variable "allowed_ports" {
  type        = list(any)
  default     = []
  description = "List of allowed ingress ports."
}

variable "protocol" {
  type        = string
  default     = "tcp"
  description = "The protocol. If not icmp, tcp, udp, or all use the."
}

variable "droplet_ids" {
  type        = list(any)
  default     = []
  description = "The ID of the VPC that the instance security group belongs to."
}

variable "load_balancer_uids" {
  type        = list(any)
  default     = []
  description = "The ID of the VPC that the load_balancer security group belongs to."
}

variable "kubernetes_ids" {
  type        = list(any)
  default     = []
  description = "The ID of the VPC that the kubernetes security group belongs to."
}

variable "tags" {
  type        = list(any)
  default     = []
  description = "An array containing the names of Tags corresponding to groups of Droplets from which the inbound traffic will be accepted."
}

variable "database_cluster_id" {
  type        = string
  default     = null
  description = "The ID of the target database cluster."
}

variable "rules" {
  type        = any
  default     = []
  description = "List of objects that represent the configuration of each inbound rule."
}

variable "outbound_rule" {
  type = list(object({
    protocol              = string
    port_range            = string
    destination_addresses = list(string)
  }))
  default = [
    {
      protocol   = "tcp"
      port_range = "1-65535"
      destination_addresses = [
        "0.0.0.0/0",
      "::/0"]
      destination_droplet_ids = []
    },
    {
      protocol   = "udp"
      port_range = "1-65535"
      destination_addresses = [
        "0.0.0.0/0",
      "::/0"]
    }
  ]
  description = "List of objects that represent the configuration of each outbound rule."
}