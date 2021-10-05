variable "name" {
  description = "The name of this Consumer Group. Changing this forces a new resource to be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group that contains the IoT hub. Changing this forces a new resource to be created."
  type        = string
}

variable "eventhub_endpoint_name" {
  description = "The name of the Event Hub-compatible endpoint in the IoT hub. Changing this forces a new resource to be created."
  type        = string
}

variable "iothub_name" {
  description = "The name of the IoT Hub. Changing this forces a new resource to be created."
  type        = string
}

variable "ip_filter" {
  description = "One or more serialization details.Example serialization inputs include type, encoding, format, and field_delimiter. Please see the example usage block for more details."
  type        = list(string)
  default     = []
}

