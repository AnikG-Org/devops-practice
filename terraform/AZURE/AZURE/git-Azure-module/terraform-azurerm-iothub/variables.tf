variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "location" {
  description = "The location of the resource group."
  type        = string
}

variable "storage_account_name" {
  description = "The name of the storage account."
  type        = string
}

variable "account_tier" {
  description = "The storage account tier, choose between Standard or Premium."
  type        = string
}

variable "account_replication_type" {
  description = "The storage account replication type, choose between LRS, GRS."
  type        = string
}

variable "storage_container_name" {
  description = "The storage container name."
  type        = string
}

variable "container_access_type" {
  description = "The container access type."
  type        = string
}

variable "iothub_name" {
  description = "The name of the iothub."
  type        = string
}

variable "sku_name" {
  description = "The name of the sku. SKU choices: B1, B2, B3, F1, S1, S2, and S3."
  type        = string
}

variable "sku_capacity" {
  description = "The number of provisioned IoT Hub units."
  type        = string
}

variable "endpoint_type" {
  description = "The type of endpoint. Possible values are AzureIotHub.StorageContainer, AzureIotHub.ServiceBusQueue, AzureIotHub.ServiceBusTopic or AzureIotHub.EventHub."
  type        = string
}

variable "endpoint_name" {
  description = "The name of the endpoint.The following names are reserved: events, operationsMonitoringEvents, fileNotifications and $default."
  type        = string
}

variable "tags" {
  description = "Tags to be used in the resource."
  type        = map(string)
}

variable "route_source" {
  description = "The source that the routing rule is to be applied to, such as DeviceMessages. Possible values include: RoutingSourceInvalid, RoutingSourceDeviceMessages, RoutingSourceTwinChangeEvents, RoutingSourceDeviceLifecycleEvents, RoutingSourceDeviceJobLifecycleEvents."
  type        = string
}

variable "route_name" {
  description = "The name of the route."
  type        = string
}

variable "endpoint_names" {
  description = "The list of endpoints to which messages that satisfy the condition are routed."
  type        = list(string)
}

variable "route_enabled" {
  description = "Used to specify whether a route is enabled."
  type        = string
}

variable "batch_frequency_in_seconds" {
  description = "Time interval at which blobs are written to storage. Value range is between 60 and 720, default value is 300. This is mandatory for endpoint type AzureIotHub.StorageContainer. "
  type        = string
  default     = "300"
}

variable "max_chunk_size_in_bytes" {
  description = "Maximum number of bytes for each blob written to storage. Value should be between 10485760(10MB) and 524288000(500MB). Default value is 314572800(300MB) and is mandatory for endpoint type AzureIotHub.StorageContainer."
  type        = string
  default     = "314572800"
}

variable "endpoint_encoding" {
  description = "Encoding that is used to serialize messages to blobs. Supported values are 'avro' and 'avrodeflate'. Default value is 'avro'. This attribute is mandatory for endpoint type AzureIotHub.StorageContainer."
  type        = string
  default     = "Avro"
}

variable "file_name_format" {
  description = "File name format for the blob. Default format is {iothub}/{partition}/{YYYY}/{MM}/{DD}/{HH}/{mm}. All parameters are mandatory but can be reordered. This attribute is mandatory for endpoint type AzureIotHub.StorageContainer."
  type        = string
  default     = "{iothub}/{partition}_{YYYY}_{MM}_{DD}_{HH}_{mm}"
}

variable "fallback_source" {
  description = "The source that the routing rule is to be applied to. Possible values include: RoutingSourceInvalid, RoutingSourceDeviceMessages, RoutingSourceTwinChangeEvents, RoutingSourceDeviceLifecycleEvents, RoutingSourceDeviceJobLifecycleEvents."
  type        = string
}

variable "condition" {
  description = "The condition that is evaluated to apply the routing rule. If no condition is provided, it evaluates to true by default."
  type        = string
  default     = "true"
}

variable "fallback_enabled" {
  description = "Used to specify whether the fallback route is enabled."
  type        = string
}

variable "ipfilter_name" {
  description = "The name of the filter."
  type        = string
}

variable "ipfilter_ip_mask" {
  description = "The IP address range in CIDR notation for the rule."
  type        = string
}

variable "iptilter_action" {
  description = "The desired action for requests captured by this rule,Possible values are Accept, Reject"
  type        = string
}

