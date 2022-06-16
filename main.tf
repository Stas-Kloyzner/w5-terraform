
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
  domain_name_label = "stas-wt-app"
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

resource "azurerm_linux_virtual_machine_scale_set" "ss" {
  name                = "app-vmss"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  sku                 = "Standard_B1s"
  instances           = var.ss_instance_number
  admin_username      = var.username
  admin_password      = var.password
  disable_password_authentication = false
  upgrade_mode = "Automatic"

  source_image_reference {
    publisher = var.image_publisher
    offer     = var.image_offer
    sku       = var.ubuntu_sku
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = "ss-nic"
    primary = true

    ip_configuration {
      name      = "internal"
      primary   = true
      subnet_id = azurerm_subnet.public-subnet.id
      load_balancer_backend_address_pool_ids =  [ azurerm_lb_backend_address_pool.lb-be-pool.id ]
      load_balancer_inbound_nat_rules_ids = [ azurerm_lb_nat_pool.lb-NAT-pool.id ]
    }
  }
  depends_on = [
    azurerm_postgresql_flexible_server.pgserver
  ]
}

resource "azurerm_virtual_machine_scale_set_extension" "ex" {
  name                         = "custom-script"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.ss.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"
  auto_upgrade_minor_version   = true
  settings = <<SETTINGS
    {
        "fileUris": ["https://${azurerm_storage_account.scriptstore.name}.blob.core.windows.net/scripts/script.sh"],
          "commandToExecute": "bash script.sh"
    }
SETTINGS
}