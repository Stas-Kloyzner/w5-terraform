#root module variables
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

variable "db_administrator_login" {
  description = "db administrator username"
  type        = string
  default     = "pgadmin"
}
variable "db_administrator_password" {
     description = "db administrator password"
  type        = string
  default     = "p@sSw0rD"
}
variable "db_zone" {
  description = "db zone"
  default     =  1
}

variable "vmss_admin_username" {
  description = "vmss admin username"
  type = string
  default = "stas"
}
variable "vmss_admin_password" {
  description = "vmss admin password"
  type        = string
  default     = "st@K24081993"
}
