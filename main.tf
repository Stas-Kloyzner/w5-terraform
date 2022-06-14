# Configure the Azure provider
terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0.2"
    }
  }

  required_version = ">= 1.1.0"
}

provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "rg" {
  name     = "w5-terraform"
  location = "eastus"
}

# Create a virtual network
resource "azurerm_virtual_network" "vnet" {
  name                = "w5-Vnet"
  address_space       = ["10.0.0.0/16"]
  location            = "eastus"
  resource_group_name = azurerm_resource_group.rg.name
}

# create public subnet
resource "azurerm_subnet" "public-subnet" {
  name                 = "public-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.0.0/24"]
}

resource "azurerm_network_security_group" "public-NSG" {
  name                = "public-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "84.94.171.112" # my ip
    destination_address_prefix = "10.0.0.0/24"
  }

  security_rule {
    name                       = "PORT_8080"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "*"
    destination_address_prefix = "10.0.0.0/24"
  }

  security_rule {
    name                       = "outbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "8080"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.0.0/24"
    destination_address_prefix = "*"
  }

}

resource "azurerm_subnet_network_security_group_association" "public-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.public-subnet.id
  network_security_group_id = azurerm_network_security_group.public-NSG.id
}


# create private subnet
resource "azurerm_subnet" "private-subnet" {
  name                 = "private-subnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes     = ["10.0.1.0/24"]
}


resource "azurerm_network_security_group" "private-NSG" {
  name                = "private-NSG"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "22"
    destination_port_range     = "22"
    source_address_prefix      = "10.0.0.0/24" # my ip
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "PORT_5432"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "5432"
    source_address_prefix      = "10.0.0.0/24"
    destination_address_prefix = "10.0.1.0/24"
  }

  security_rule {
    name                       = "outbound"
    priority                   = 120
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "5432"
    destination_port_range     = "*"
    source_address_prefix      = "10.0.1.0/24"
    destination_address_prefix = "10.0.0.0/24"
  }
}

resource "azurerm_subnet_network_security_group_association" "private-subnet-nsg-association" {
  subnet_id                 = azurerm_subnet.private-subnet.id
  network_security_group_id = azurerm_network_security_group.private-NSG.id
}