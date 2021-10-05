variable "resource_group_name" {
  description = "The name of the resource group in which the Cosmos DB Mongo Database is created. Changing this forces a new resource to be created."
  type        = string
}

variable "account_name" {
  description = "The name of the CosmosDB account. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "The name of the CosmosDB Mongo Database. Changing this forces a new resource to be created."
  type        = string
}

