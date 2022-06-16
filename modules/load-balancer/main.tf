#load balancer
resource "azurerm_lb" "lb" {
  name                = "lb"
  resource_group_name = var.resource_group_name
  location            = var.location
  sku="Standard"
  sku_tier = "Regional"
  frontend_ip_configuration {
    name                 = var.frontend_ip_configuration_name
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
  resource_group_name = var.resource_group_name
  location            = var.location
  allocation_method   = "Static"
  sku="Standard"
}
# load balancer health probe
resource "azurerm_lb_probe" "hp" {
  loadbalancer_id     = azurerm_lb.lb.id
  name                = "hp"
  port                = 8080
  protocol            =  "Tcp"
}
# load balancing rule
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
#load balancer NAT rule
resource "azurerm_lb_nat_pool" "lb-NAT-pool" {
  resource_group_name            = var.resource_group_name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "lb-nat-pool"
  protocol                       = "Tcp"
  frontend_port_start            = 22
  frontend_port_end              = 32
  backend_port                   = 22
  frontend_ip_configuration_name = var.frontend_ip_configuration_name
}
#associate nic to backend pool
resource "azurerm_network_interface_backend_address_pool_association" "associate_nic-be_pool" {
  network_interface_id    = var.network_interface_id
  ip_configuration_name   = var.ip_configuration_name
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-be-pool.id
}
