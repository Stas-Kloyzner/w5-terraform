# network module variables
variable "resource_group_name" {}
variable "location" {}
variable "vnet_name" {
  description = "the name of the vnet to be created"
  type        = string
  default     = "vnet"
}
variable "vnet_address_space" {
  description = "the vnet address space"
  type        = string
  default     = "10.0.0.0/16"
}