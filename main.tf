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
  name     = var.rg_name
  location = var.location
}

#load balancer
resource "azurerm_lb" "lb" {
  name                = "lb"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku="Standard"
  sku_tier = "Regional"
  frontend_ip_configuration {
    name                 = "frontend-ip"
    public_ip_address_id = azurerm_public_ip.lb-ip.id
  }
}
# load balancer backend pool
resource "azurerm_lb_backend_address_pool" "lb-be-pool" {
  loadbalancer_id = azurerm_lb.lb.id
  name            = "lb-be-pool"
}

# load balancer public IP address
resource "azurerm_public_ip" "lb-ip" {
  name                = "lb-ip"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  allocation_method   = "Static"
  sku="Standard"
}

// load balancer health probe
resource "azurerm_lb_probe" "hp" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "hp"
  port                = 8080
  protocol            =  "Tcp"
}

// Here we are defining the Load Balancing Rule
resource "azurerm_lb_rule" "lb-rule-1" {
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "rule-1"
  protocol                       = "Tcp"
  frontend_port                  = 8080
  backend_port                   = 8080
  frontend_ip_configuration_name = "frontend-ip"
  backend_address_pool_ids       = [ azurerm_lb_backend_address_pool.lb-be-pool.id ]
  probe_id                       = azurerm_lb_probe.hp.id
}