# Resource Group variables
variable "rg_name" {
  description = "the name of the resource group to be created"
  type        = string
  default     = "w5-terraform"
}
variable "location" {
  description = "location of the resource group"
  type        = string
  default     = "eastus"
}

# Vnet variables
variable "vnet_name" {
  description = "the name of the vnet to be created"
  type        = string
  default     = "w5-Vnet"
}
variable "vnet_address_space" {
  description = "the vnet address space"
  type        = string
  default     = "10.0.0.0/16"
}

