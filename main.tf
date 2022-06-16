
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
    name                 = var.frontend_ip
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
  resource_group_name            = azurerm_resource_group.rg.name
  loadbalancer_id                = azurerm_lb.lb.id
  name                           = "lb-be-pool"
  protocol                       = "Tcp"
  frontend_port_start            = 22
  frontend_port_end              = 32
  backend_port                   = 22
  frontend_ip_configuration_name = "frontend-ip"
}

resource "azurerm_network_interface" "nic" {
  name                = "nic-1"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                                   = "internal-ip"
    subnet_id                              = azurerm_subnet.public-subnet.id
    private_ip_address_allocation          = "Dynamic"
  }
}
#associate nic to backend pool
resource "azurerm_network_interface_backend_address_pool_association" "associate_nic-be_pool" {
  network_interface_id    = azurerm_network_interface.nic.id
  ip_configuration_name   = azurerm_network_interface.nic.ip_configuration[0].name #"internal-ip"
  backend_address_pool_id = azurerm_lb_backend_address_pool.lb-be-pool.id
}

module "vm_scale_set" {
  source = "modules/linux vm scale-set"

  resource_group_name= azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  subnet_id = azurerm_subnet.public-subnet.id
  load_balancer_backend_address_pool_ids = [ azurerm_lb_backend_address_pool.lb-be-pool.id ]
  load_balancer_inbound_nat_rules_ids = [ azurerm_lb_nat_pool.lb-NAT-pool.id ]


variable  "admin_username" {
  type        = string
  description = "scaleset username"
  default     = "stas"
}
variable "admin_password" {
  type        = string
  description = "scaleset password"
  default     = "st@K24081993"
}
variable "instances" {
  type        = number
  description = "number of scaleset instances"
  default     = 1
}
variable "upgrade_mode" {
  type        = string
  description = "scaleset upgrade mode"
  default     = "Automatic"
}
variable "network_interface_name" {
  type        = string
  description = "scaleset upgrade mode"
  default     = "ss-nic-1"
}
# vmss ip configuration varibles
variable "ip_configuration_name" {
  type        = string
  description = "scaleset upgrade mode"
  default     = "internal"
}
variable "subnet_id" {}
variable "load_balancer_backend_address_pool_ids" {}
variable "load_balancer_inbound_nat_rules_ids" {}




  depends_on = [
    azurerm_postgresql_flexible_server.pgserver
  ]
}