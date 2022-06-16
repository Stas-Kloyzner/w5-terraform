output "ss_password" {
  value = azurerm_linux_virtual_machine_scale_set.ss.admin_password
  sensitive = true
}