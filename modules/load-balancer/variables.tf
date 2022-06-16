#load balancer variables
variable "resource_group_name" {}
variable "location" {}
variable "frontend_ip_configuration_name" {
  description = "the name of the frontend_ip_configuration"
  type        = string
  default     = "lb-frontend_ip"
}
variable "network_interface_id" {}    #= azurerm_network_interface.nic.id
variable "ip_configuration_name" {}   #= azurerm_network_interface.nic.ip_configuration[0].name #"internal-ip"