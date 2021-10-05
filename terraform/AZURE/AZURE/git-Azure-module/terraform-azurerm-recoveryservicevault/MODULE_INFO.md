
# Recovery Service Vault

- The module will create a recovery service vault in the selected Resource Group
- There are four different Log Analytics Workspace that has been provisioned with this module.
    - The mapping has been done on the basis of the TFE Instance.
    - The available Hosting Regions for Log Analytics Workspace are:

| Hosting Region   | TFE Instance  | Log Analytics Workspace|
| ------------- | ------------- | ------------- |
| eastus |  tfe.pwc.com |  East US Azure/gx-zu2applop999|
| eastus |  global.tfe.pwcinternal.com|  East US Azure/gx-zu2applop999|
|westus  |  west.tfe.pwcinternal.com  |  West US Azure/Gx-zu7applop999|
| westeurope|  central.tfe.pwcinternal.com|  West Europe Azure/gx-zweapplop999|
| southeastasia|  east.tfe.pwcinternal.com|  Southeast Asia Azure/gx-zseapplop999|

