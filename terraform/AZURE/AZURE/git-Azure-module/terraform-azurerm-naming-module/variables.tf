variable "vm_numbering_starts_with" {
  type        = number
  description = "VM naming module sequence number"
  default     = 0
}

variable "vm_count" {
  type        = number
  description = "Count of VMs"
  default     = 10
}

variable "rg_count" {
  type        = number
  description = "Count of Resource groups"
  default     = 1
}

variable "storage_acc_count" {
  type        = number
  description = "Count of storage accounts to be created"
  default     = 3
}

variable "asg_app_codes" {
  type        = list(string)
  description = "List of 4-letter app codes for creating ASG names"
  default     = null
}

variable "asg_number" {
  type        = number
  description = "ASG sequence number for naming"
  default     = 1
}

variable "law_count" {
  type        = number
  description = "Count of Log Analytics Workspace"
  default     = 1
}

variable "rsv_count" {
  type        = number
  description = "Count of RSVs"
  default     = 1
}

variable "lb_count" {
  type        = number
  description = "Count of Load balancers"
  default     = 1
}

variable "kv_count" {
  type        = number
  description = "Count of Keyvaults"
  default     = 1
}

variable "agw_count" {
  type        = number
  description = "Count of Application Gateways"
  default     = 1
}

variable "avs_count" {
  type        = number
  description = "Count of Availability Sets"
  default     = 1
}

variable "subnet_count" {
  type        = number
  description = "Count of subnets"
  default     = 1
}

variable "srb_count" {
  type        = number
  description = "Count of service bus"
  default     = 1
}

variable "ehb_count" {
  type        = number
  description = "Count of Event hub namespace"
  default     = 1
}

variable "cdb_count" {
  type        = number
  description = "Count of CosmosDB"
  default     = 1
}

variable "rdc_count" {
  type        = number
  description = "Count of Redis Cache"
  default     = 1
}

variable "ssvc_count" {
  type        = number
  description = "Count of search service"
  default     = 1
}

variable "mssq_count" {
  type        = number
  description = "Count of MS SQL server"
  default     = 1
}

variable "mysq_count" {
  type        = number
  description = "Count of MySQL server"
  default     = 1
}

variable "pgsq_count" {
  type        = number
  description = "Count of PostgreSQL server"
  default     = 1
}

variable "app_count" {
  type        = number
  description = "Count of App service"
  default     = 1
}

variable "sig_count" {
  type        = number
  description = "Count of Signal R"
  default     = 1
}

variable "adf_count" {
  type        = number
  description = "Count of Azure data factory"
  default     = 1
}

variable "subscription_name" {
  type        = string
  description = "Name of the subscription in which resources are to be created"
}

variable "location" {
  type        = string
  description = "Location"
}

variable "secondary_location" {
  type        = string
  description = "Secondary location"
  default     = null
}

variable "regional_pair_code" {
  type = string
  description = "Single letter regional pair code to use for name sequencing."
  default = null
}

variable "app_code" {
  type        = string
  description = "App Code"
}

variable "vm_app_codes" {
  type        = list(string)
  description = "List of 3-letter app codes for VM"
  default     = null
}

variable "app_env_code" {
  default     = null
  type        = string
  description = "App Environment Code"
}

variable "environment" {
  type        = string
  description = "Environment Name"
}

variable "storage_acc_replication_type" {
  description = "Storage account replication type (LRS/GRS/RAGRS/ZRS)"
  default     = null
}

variable "udr_codes" {
  description = "Codes for UDR names"
  default     = ["SLBR", "BYP4", "BYP5"]
}
