## Description
This is a terraform template for creating an azure infrastructure containing a vm scale set and a managed postgres db service,
the postgres db is in a private subnet , accessible only from the vms in the public subnet, the vms are all connected to a load balancer.

The backend is configured to store the tfstate file remotely in azure storage, the storage details should be configured in the backend.tf file.

The file variables.tf contains default paramesers (vm username, password, region ...) and should be edited with your own parameters before building the infrastructure.

## Usage
1) install terraform on your machine (https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/azure-get-started) and configure your azure subscription (https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/guides/service_principal_client_secret)

2) from the directory containing the terraform files run in terminal :

-$ terraform init

-$ terraform plan

-$ terraform apply

3) To destroy the infrastructure , run in terminal :

-$ terraform destroy
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | ~> 3.0.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 3.0.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_Vnet"></a> [Vnet](#module\_Vnet) | ./modules/network | n/a |
| <a name="module_lb"></a> [lb](#module\_lb) | ./modules/load-balancer | n/a |
| <a name="module_pg_f_db"></a> [pg\_f\_db](#module\_pg\_f\_db) | ./modules/db | n/a |
| <a name="module_vm_scale_set"></a> [vm\_scale\_set](#module\_vm\_scale\_set) | ./modules/linux vm scale-set | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_resource_group.rg](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_db_administrator_login"></a> [db\_administrator\_login](#input\_db\_administrator\_login) | db administrator username | `string` | `"pgadmin"` | no |
| <a name="input_db_administrator_password"></a> [db\_administrator\_password](#input\_db\_administrator\_password) | db administrator password | `string` | `"p@sSw0rD"` | no |
| <a name="input_db_zone"></a> [db\_zone](#input\_db\_zone) | db zone | `number` | `1` | no |
| <a name="input_location"></a> [location](#input\_location) | location of the resource group | `string` | `"eastus"` | no |
| <a name="input_rg_name"></a> [rg\_name](#input\_rg\_name) | the name of the resource group to be created | `string` | `"w5-terraform"` | no |
| <a name="input_vmss_admin_password"></a> [vmss\_admin\_password](#input\_vmss\_admin\_password) | vmss admin password | `string` | `"st@K24081993"` | no |
| <a name="input_vmss_admin_username"></a> [vmss\_admin\_username](#input\_vmss\_admin\_username) | vmss admin username | `string` | `"stas"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ss_password"></a> [ss\_password](#output\_ss\_password) | root module output |
