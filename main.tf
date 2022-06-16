#root module main
resource "azurerm_resource_group" "rg" {
  name     = var.rg_name
  location = var.location
}

module "Vnet" {
  source = "./modules/network"

  resource_group_name= azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
}
#load balancer
module "lb" {
  source = "./modules/load-balancer"

  resource_group_name= azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  network_interface_id = module.vm_scale_set.network_interface_id
  ip_configuration_name = module.vm_scale_set.ip_configuration_name
}
# postgres db
module "pg_f_db" {
  source = "./modules/db"

  resource_group_name= azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  virtual_network_name = module.Vnet.name
  virtual_network_id = module.Vnet.vnet_id
  administrator_login = "pgadmin"
  administrator_password = "p@sSw0rD"
  zone = 1
}
#linux vm scale set
module "vm_scale_set" {
  source = "./modules/linux vm scale-set"

  resource_group_name= azurerm_resource_group.rg.name
  location = azurerm_resource_group.rg.location
  subnet_id = module.Vnet.subnet_id
  load_balancer_backend_address_pool_ids = module.lb.load_balancer_backend_address_pool_ids
  load_balancer_inbound_nat_rules_ids = module.lb.load_balancer_inbound_nat_rules_ids
  admin_username = "stas"
  admin_password = "st@K24081993"

  depends_on = [module.pg_f_db]
}
