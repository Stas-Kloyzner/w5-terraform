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
