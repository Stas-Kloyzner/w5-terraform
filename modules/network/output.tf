output "name" {
  value = azurerm_virtual_network.vnet.name
}
output "subnet_id" {
  value = azurerm_subnet.public-subnet.id
}
output "vnet_id" {
  value = azurerm_virtual_network.vnet.id
}
