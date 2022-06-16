#resource "azurerm_storage_account" "tfstate" {
#  name                     = "tfstate1234567"
#  resource_group_name      = azurerm_resource_group.rg.name
#  location                 = azurerm_resource_group.rg.location
#  account_tier             = "Standard"
#  account_replication_type = "LRS"
#}
#resource "azurerm_storage_container" "tfstate" {
#  name                  = "tfstate-container"
#  storage_account_name  = azurerm_storage_account.tfstate.name
#  container_access_type = "blob"
#}
#resource "azurerm_storage_blob" "script" {
#  name                   = "tfstate-blob"
#  storage_account_name   = azurerm_storage_account.tfstate.name
#  storage_container_name = azurerm_storage_container.tfstate.name
#  type                   = "Block"
#  source                 = "script.sh"
#}
