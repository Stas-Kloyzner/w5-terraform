resource "azurerm_postgresql_flexible_server" "pgserver" {
  name                   = var.pg_f_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = "13"
  delegated_subnet_id    = azurerm_subnet.private-subnet.id
  private_dns_zone_id    = azurerm_private_dns_zone.private_dns_zone.id
  administrator_login    = var.administrator_login
  administrator_password = var.administrator_password
  zone                   = var.zone

  storage_mb = var.storage_mb

  sku_name   = "B_Standard_B1ms"
  depends_on = [azurerm_private_dns_zone_virtual_network_link.dns-vnet-link]

}

resource "azurerm_postgresql_flexible_server_configuration" "ssl" {
  name                = "require_secure_transport"
  server_id = azurerm_postgresql_flexible_server.pgserver.id
  value               = "off"
}