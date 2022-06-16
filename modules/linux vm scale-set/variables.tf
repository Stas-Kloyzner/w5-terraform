# vmss variables
variable  "ss_name" {
  type        = string
  description = "scale set name"
  default     = "stas"
}
variable "resource_group_name" {}
variable "location" {}
variable  "admin_username" {
  type        = string
  description = "scaleset admin username"
  default     = "ssadmin"
}
variable "admin_password" {
  type        = string
  description = "scaleset admin password"
  default     = "superSECRETp@ssw0rd!"
}
variable "instances" {
  type        = number
  description = "number of scaleset instances"
  default     = 1
}
variable "upgrade_mode" {
  type        = string
  description = "scaleset upgrade mode"
  default     = "Automatic"
}
variable "network_interface_name" {
  type        = string
  description = "scaleset network interface name"
  default     = "ss-nic-1"
}
# vmss ip configuration varibles
variable "ip_configuration_name" {
  type        = string
  description = "scaleset ip configuration name"
  default     = "internal"
}
variable "subnet_id" {}
variable "load_balancer_backend_address_pool_ids" {}
variable "load_balancer_inbound_nat_rules_ids" {}