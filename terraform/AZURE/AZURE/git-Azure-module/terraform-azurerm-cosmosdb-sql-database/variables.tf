variable "resource_group_name" {
  description = "The name of the resource group in which the Cosmos DB SQL database is created. Changing this forces a new resource to be created."
  type        = string
}

variable "account_name" {
  description = "The name of the CosmosDB SQL account. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "The name of the CosmosDB SQL database. Changing this forces a new resource to be created."
  type        = string
}

variable "throughput" {
  type        = number
  description = "The throughput of SQL database (RU/s). Must be set in increments of 100. The minimum value is 400."
  default     = null
}

variable "max_throughput" {
  type        = number
  description = "The maximum throughput of the SQL database (RU/s). Must be between 4,000 and 1,000,000. Must be set in increments of 1,000. Conflicts with throughput."
  default     = null
}
