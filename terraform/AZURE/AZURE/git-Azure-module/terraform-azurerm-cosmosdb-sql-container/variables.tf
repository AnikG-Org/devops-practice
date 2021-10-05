variable "resource_group_name" {
  description = "The name of the resource group in which the Cosmos DB SQL container is created. Changing this forces a new resource to be created."
  type        = string
}

variable "account_name" {
  description = "The name of the Cosmos DB Account to create the container within. Changing this forces a new resource to be created."
  type        = string
}

variable "database_name" {
  description = "The name of the Cosmos DB SQL Database to create the container within. Changing this forces a new resource to be created."
  type        = string
}

variable "name" {
  description = "The name of the CosmosDB SQL container. Changing this forces a new resource to be created."
  type        = string
}

variable "partition_key_path" {
  description = "Define a partition key. Changing this forces a new resource to be created."
  type        = string
}

variable "unique_key" {
  description = "A list of paths to use for this unique key."
  type        = any
  default     = []
}

variable "throughput" {
  type        = number
  description = "The throughput of SQL container (RU/s). Must be set in increments of 100. The minimum value is 400."
  default     = null
}

variable "max_throughput" {
  type        = number
  description = "The maximum throughput of the SQL container (RU/s). Must be between 4,000 and 1,000,000. Must be set in increments of 1,000. Conflicts with throughput."
  default     = null
}
