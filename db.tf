
resource "azurerm_postgresql_flexible_server" "pgserver" {
  name                   = "pg-f-server"
  resource_group_name    = azurerm_resource_group.rg.name
  location               = azurerm_resource_group.rg.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.private-subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns_zone.id
  administrator_login    = "pgadmin"
  administrator_password = "p@sSw0rD"
  zone                   = "1"

  storage_mb = 32768

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns-vnet-link]

}

resource "azurerm_postgresql_flexible_server_configuration" "ssl" {
  name                = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.pgserver.id
  value               = "off"
}