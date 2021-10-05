# terraform-azurerm-naming-module

## Usage
``` terraform
# module "naming" {
#   source                   = "../../"
#   subscription_name        = data.terraform_remote_state.devops_subscription_base_state.outputs.subscription_name
#   location                 = data.terraform_remote_state.devops_subscription_base_state.outputs.base_vnet_location
#   app_code                 = var.app_code
#   environment              = var.environment
#   vm_numbering_starts_with = var.vm_numbering_starts_with
# }

```

## Providers

No provider.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| app\_code | App Code | `string` | n/a | yes |
| environment | Environment Name | `string` | n/a | yes |
| location | Location | `string` | n/a | yes |
| subscription\_name | Name of the subscription in which resources are to be created | `string` | n/a | yes |
| adf\_count | Count of Azure data factory | `number` | `1` | no |
| agw\_count | Count of Application Gateways | `number` | `1` | no |
| app\_count | Count of App service | `number` | `1` | no |
| app\_env\_code | App Environment Code | `string` | `null` | no |
| asg\_app\_codes | List of 4-letter app codes for creating ASG names | `list(string)` | `null` | no |
| asg\_number | ASG sequence number for naming | `number` | `1` | no |
| avs\_count | Count of Availability Sets | `number` | `1` | no |
| cdb\_count | Count of CosmosDB | `number` | `1` | no |
| ehb\_count | Count of Event hub namespace | `number` | `1` | no |
| kv\_count | Count of Keyvaults | `number` | `1` | no |
| law\_count | Count of Log Analytics Workspace | `number` | `1` | no |
| lb\_count | Count of Load balancers | `number` | `1` | no |
| mssq\_count | Count of MS SQL server | `number` | `1` | no |
| mysq\_count | Count of MySQL server | `number` | `1` | no |
| pgsq\_count | Count of PostgreSQL server | `number` | `1` | no |
| rdc\_count | Count of Redis Cache | `number` | `1` | no |
| regional\_pair\_code | Single letter regional pair code to use for name sequencing. | `string` | `null` | no |
| rg\_count | Count of Resource groups | `number` | `1` | no |
| rsv\_count | Count of RSVs | `number` | `1` | no |
| secondary\_location | Secondary location | `string` | `null` | no |
| sig\_count | Count of Signal R | `number` | `1` | no |
| srb\_count | Count of service bus | `number` | `1` | no |
| ssvc\_count | Count of search service | `number` | `1` | no |
| storage\_acc\_count | Count of storage accounts to be created | `number` | `3` | no |
| storage\_acc\_replication\_type | Storage account replication type (LRS/GRS/RAGRS/ZRS) | `any` | `null` | no |
| subnet\_count | Count of subnets | `number` | `1` | no |
| udr\_codes | Codes for UDR names | `list` | <pre>[<br>  "SLBR",<br>  "BYP4",<br>  "BYP5"<br>]</pre> | no |
| vm\_app\_codes | List of 3-letter app codes for VM | `list(string)` | `null` | no |
| vm\_count | Count of VMs | `number` | `10` | no |
| vm\_numbering\_starts\_with | VM naming module sequence number | `number` | `0` | no |

## Outputs

| Name | Description |
|------|-------------|
| adf\_names | n/a |
| agw\_names | n/a |
| app\_names | n/a |
| asg\_names | n/a |
| asp\_names | n/a |
| avs\_names | n/a |
| azf\_names | n/a |
| cdb\_names | n/a |
| ehb\_names | n/a |
| kv\_names | n/a |
| law\_names | n/a |
| lb\_names | n/a |
| linux\_vm\_names | n/a |
| mssq\_names | n/a |
| mysq\_names | n/a |
| nsg\_names | n/a |
| pgsq\_names | n/a |
| premium\_sa\_names | n/a |
| rdc\_names | n/a |
| rg\_names | n/a |
| rsv\_names | n/a |
| sig\_names | n/a |
| srb\_names | n/a |
| ssvc\_names | n/a |
| standard\_sa\_names | n/a |
| subnet\_names | n/a |
| udr\_names | n/a |
| windows\_vm\_names | n/a |

## Release Notes

The newest published version of this module is v5.5.9.

- View the complete change log [here](./changelog.md)
