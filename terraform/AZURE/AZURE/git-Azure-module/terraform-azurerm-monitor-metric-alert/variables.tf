variable "name" {
  description = "Specifies the name of the monitor metric alert to be created"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the metric alert."
}

variable "scopes" {
  description = "The resource ID at which the metric criteria should be applied."
  type        = list(string)
  default     = []
}

variable "description" {
  description = "Descrition of the monitor metric alert"
}

variable "frequency" {
  description = "The evaluation frequency of this Metric Alert. Possible Values are 1M, 5M, 15M, 30M, 1H"
  default     = "1M"
}

variable "window_size" {
  description = "The period of time that is used to monitor alert activity.This value must be greater than frequency.Possible values are 1M, 5M, 15M, 30M, 1H, 6H, 12H, 24H"
  default     = "5M"
}

variable "action_group_id" {
  description = "Specifies the id of the monitoring action group through which alerts are notified"
  default     = ""
}

variable "metric_namespace" {
  description = "Metric namespace to be monitored"
  type        = string
}

variable "metric_name" {
  description = "Metric name to be monitored"
  type        = string
}

variable "aggregation" {
  description = "The statistic that runs over the metric values. Possible values are Average, Minimum, Maximum and Total."
  type        = string
}

variable "operator" {
  description = "The criteria operator. Possible values are Equals, NotEquals, GreaterThan, GreaterThanOrEqual, LessThan and LessThanOrEqual."
  type        = string
}

variable "threshold" {
  description = "The criteria threshold value that activates the alert."
  type        = string
}

variable "tags" {
  type        = map(string)
  description = "A mapping of tags to assign to the resource"
  default     = {}
}

