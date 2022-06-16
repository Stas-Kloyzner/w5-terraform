# vmss module output
output "scaleset_password" {
  value = azurerm_linux_virtual_machine_scale_set.scaleset.admin_password
  sensitive = true
}
output "network_interface_name" {
  value = azurerm_network_interface.nic.name
}
output "ip_configuration_name" {
value =azurerm_network_interface.nic.ip_configuration[0].name
}
output "network_interface_id" {
  value =azurerm_network_interface.nic.id
}

