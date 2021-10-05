variable "name" {
  description = "The name of the Stream output EventHub."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the Resource Group where the Stream Analytics Job exists."
  type        = string
}

variable "stream_analytics_job_name" {
  description = "The name of the Stream Analytics Job."
  type        = string
}

variable "eventhub_name" {
  description = "The name of the Event Hub."
  type        = string
}

variable "servicebus_namespace" {
  description = "The namespace that is associated with the desired Event Hub, Service Bus Queue, Service Bus Topic, etc."
  type        = string
}

variable "shared_access_policy_key" {
  description = "The shared access policy key for the specified shared access policy."
  type        = string
}

variable "shared_access_policy_name" {
  description = "The shared access policy name for the Event Hub, Service Bus Queue, Service Bus Topic, etc."
  type        = string
}

variable "serialization" {
  description = "One or more serialization details.Example serialization inputs include type, encoding, format, and field_delimiter. Please see the example usage block for more details."
  type        = list
  default     = []
}

