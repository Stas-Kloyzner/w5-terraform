output "scaleset_password" {
  value = azurerm_linux_virtual_machine_scale_set.scaleset.admin_password
  sensitive = true
}
output "network_interface_name" {
  value = azurerm_network_interface.nic.name
}
output "azurerm_network_interface" {
value =azurerm_network_interface.nic.ip_configuration[0].name #"internal-ip"
}