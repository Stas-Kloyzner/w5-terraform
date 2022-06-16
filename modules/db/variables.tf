# db module variables
variable "resource_group_name" {}
variable "location" {}
variable "virtual_network_name" {}
variable "virtual_network_id" {}
variable "pg_f_server_name" {
  type        = string
  description = "pg flexible server name"
  default     = "pg-f-server"
}
variable "administrator_login" {}
variable "administrator_password" {}
variable "zone" {}
variable "storage_mb" {
  type        = number
  description = "pg flexible server storage size in mb"
  default     = 32768
}