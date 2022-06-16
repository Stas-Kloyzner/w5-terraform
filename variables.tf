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

variable "frontend_ip" {
  type        = string
  default     = "frontend-ip"
}

# ss vm variables
variable "image_publisher" {
  type        = string
  description = "Virtual machine source image publisher"
  default     = "Canonical"
}

variable "image_offer" {
  type        = string
  description = "Virtual machine source image offer"
  default     = "0001-com-ubuntu-server-focal"
}

variable "ubuntu_sku" {
  type        = string
  description = "SKU for Ubuntu 20.04 LTS Gen2"
  default     = "20_04-lts-gen2"
}

variable  "username" {
  type        = string
  description = "scaleset username"
  default     = "stas"
}

variable "password" {
  type        = string
  description = "scaleset password"
  default     = "st@K24081993"
}

variable "ss_instance_number" {
  type        = number
  description = "number of scaleset instances"
  default     = 1
}
