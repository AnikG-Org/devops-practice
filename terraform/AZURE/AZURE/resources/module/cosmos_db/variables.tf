variable "name" {
  description = "Name of the CosmosDB Account."
}

variable "resource_group_name" {
  description = "Name of resource group to deploy resources in."
}

variable "location" {
  description = "The Azure Region in which to create resource."
}

variable "tags" {
  description = "Tags to apply to all resources created."
  type        = map(string)
  default     = {}
}
variable "offer_type"{

}
variable "kind"{

}
variable "enable_automatic_failover"{

}
variable "consistency_level"{

}
variable "max_interval_in_seconds"{

}
variable "max_staleness_prefix"{

}
variable "failover_priority"{

}
