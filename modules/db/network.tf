# pg network
resource "azurerm_subnet" "private-subnet" {
  name                 = "private-subnet"
  resource_group_name  = var.resource_group_name
  virtual_network_name = var.virtual_network_name
  address_prefixes     = ["10.0.1.0/24"]
  service_endpoints    = ["Microsoft.Storage"]
  delegation {
    name = "fs"
    service_delegation {
      name = "Microsoft.DBforPostgreSQL/flexibleServers"
      actions = [
        "Microsoft.Network/virtualNetworks/subnets/join/action",
      ]
    }
  }
}

resource "azurerm_network_security_group" "private-NSG" {
  name                = "private-NSG"
  location            = var.location
  resource_group_name = var.resource_group_name
# ssh
  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/24"
    destination_address_prefix = "*"
  }
# port 5432
  security_rule {
    name                       = "PORT_5432"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.0.0/24"
    destination_address_prefix = "*"
  }
# inbound deny all
  security_rule {
    name                       = "deny_all"
    priority                   = 1010
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
# outbound to public subnet
  security_rule {
    name                       = "outbound"
    priority                   = 2000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.0/24"
  }
# outbound deny all
  security_rule {
  name                       = "outbound"
  priority                   = 2010
  direction                  = "Outbound"
  access                     = "Deny"
  protocol                   = "*"
  source_port_range          = "*"
  destination_port_range     = "*"
  source_address_prefix      = "*"
  destination_address_prefix = "*"
  }
}

resource "azurerm_subnet_network_security_group_association" "private-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.private-subnet.id
  network_security_group_id = azurerm_network_security_group.private-NSG.id
}

resource "azurerm_private_dns_zone" "private_dns_zone" {
  name                = "pgserver.postgres.database.azure.com"
  resource_group_name = var.resource_group_name
}

resource "azurerm_private_dns_zone_virtual_network_link" "dns-vnet-link" {
  name                  = "dns-vnet-link"
  private_dns_zone_name = azurerm_private_dns_zone.private_dns_zone.name
  virtual_network_id    = var.virtual_network_id
  resource_group_name   = var.resource_group_name
}
