### Variables ###
variable "name" {
  description = "The name of the monitor activity log alert."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group."
  type        = string
}

variable "monitor_action_group_name" {
  description = "The name of the monitor action group."
  type        = string
}

variable "description" {
  description = "A description for this monitor activity log alert."
  type        = string
}

variable "scopes" {
  description = "The Scope at which the Activity Log should be applied, for example a the Resource ID of a Subscription or a Resource (such as a Storage Account)."
  type        = list(string)
}

variable "enabled" {
  description = "Enable this Activity Log Alert."
  type        = string
  default     = "true"
}

variable "resource_id" {
  description = "The specific resource monitored by the activity log alert. It should be within one of the scopes."
  type        = string
  default     = ""
}

variable "operation_name" {
  description = "The Resource Manager Role-Based Access Control operation name. Supported operation should be of the form: <resourceProvider>/<resourceType>/<operation>."
  type        = string
}

variable "category" {
  description = "The category of the operation. Possible values are Administrative, Autoscale, Policy, Recommendation, Security and Service Health."
  type        = string
}

variable "level" {
  description = "The severity level of the event. Possible values are Verbose, Informational, Warning, Error, and Critical."
  type        = string
}

variable "status" {
  description = "The status of the event. For example, Started, Failed, or Succeeded."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the monitor activy log alert."
  type        = map(string)
}

