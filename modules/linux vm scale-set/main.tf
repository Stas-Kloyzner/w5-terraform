resource "azurerm_linux_virtual_machine_scale_set" "scaleset" {
  name                = var.ss_name
  resource_group_name = var.resource_group_name
  location            = var.location
  sku                 = "Standard_B1s"
  instances           = var.instances
  admin_username      = var.admin_username
  admin_password      = var.admin_password
  disable_password_authentication = false
  upgrade_mode = var.upgrade_mode

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-focal"
    sku       = "20_04-lts-gen2"
    version   = "latest"
  }

  os_disk {
    storage_account_type = "Standard_LRS"
    caching              = "ReadWrite"
  }

  network_interface {
    name    = var.network_interface_name
    primary = true

    ip_configuration {
      name      = var.ip_configuration_name
      primary   = true
      subnet_id = var.subnet_id
      load_balancer_backend_address_pool_ids =  var.load_balancer_backend_address_pool_ids
      load_balancer_inbound_nat_rules_ids = var.load_balancer_inbound_nat_rules_ids
    }
  }
}

resource "azurerm_virtual_machine_scale_set_extension" "extension" {
  name                         = "custom-script"
  virtual_machine_scale_set_id = azurerm_linux_virtual_machine_scale_set.scaleset.id
  publisher                    = "Microsoft.Azure.Extensions"
  type                         = "CustomScript"
  type_handler_version         = "2.0"
  auto_upgrade_minor_version   = true
  settings = <<SETTINGS
    {
        "fileUris": ["https://scriptstore1234567.blob.core.windows.net/scripts/script.sh"],
          "commandToExecute": "bash script.sh"
    }
SETTINGS
}

resource "azurerm_monitor_autoscale_setting" "scaling-setting" {
  name                = "scaling-setting"
  resource_group_name = azurerm_linux_virtual_machine_scale_set.scaleset.resource_group_name
  location            = azurerm_linux_virtual_machine_scale_set.scaleset.location
  target_resource_id  = azurerm_linux_virtual_machine_scale_set.scaleset.id

  profile {
    name = "defaultProfile"

    capacity {
      default = azurerm_linux_virtual_machine_scale_set.scaleset.instances
      minimum = 1
      maximum = 10
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.scaleset.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 75
        metric_namespace   = "microsoft.compute/virtualmachinescalesets"
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }

    rule {
      metric_trigger {
        metric_name        = "Percentage CPU"
        metric_resource_id = azurerm_linux_virtual_machine_scale_set.scaleset.id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "LessThan"
        threshold          = 25
      }

      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}