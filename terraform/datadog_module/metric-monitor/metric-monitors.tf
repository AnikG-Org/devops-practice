
# Create a new Datadog monitor
resource "datadog_monitor" "resource" {
  count              = (var.metrics_monitor != null) ? length(var.metrics_monitor) : 0
  name               = var.metrics_monitor[count.index]["alert_name"]
  type               = var.metrics_monitor[count.index]["type"]
  message            = var.metrics_monitor[count.index]["message"]
#   escalation_message = var.metrics_monitor[count.index]["escalation_message"]

  query = var.metrics_monitor[count.index]["query"]

  monitor_thresholds {
    # warning           = var.metrics_monitor[count.index]["warning"]
    # warning_recovery  = var.metrics_monitor[count.index]["warning_recovery"]
    critical          = var.metrics_monitor[count.index]["critical"]
    critical_recovery = var.metrics_monitor[count.index]["critical_recovery"]
  }

  notify_no_data    = var.notify_no_data
  renotify_interval = var.renotify_interval

  notify_audit = var.notify_audit
  timeout_h    = var.timeout_h

  priority = var.metrics_monitor[count.index]["priority"]

  include_tags = var.include_tags
#   tags         = merge(var.metrics_monitor[count.index]["tags"], local.common_tags)
  tags = var.metrics_monitor[count.index]["tags"] 
}

################################################################################
# VAR
################################################################################

variable "include_tags" {
  type        = bool
  default     = true
  description = "whether notifications from this monitor automatically insert its triggering tags into the title"
}

variable "notify_no_data" {
  type        = bool
  default     = false
  description = "A boolean indicating whether this monitor will notify when data stops reporting"
}
variable "notify_audit" {
  type        = bool
  default     = false
  description = "A boolean indicating whether tagged users will be notified on changes to this monitor"
}
variable "renotify_interval" {
  type        = number
  default     = 180  
  description = "The number of minutes after the last notification before a monitor will re-notify on the current status. It will only re-notify if it's not resolved."
}

variable "timeout_h" {
  type        = number
  default     = 60  
  description = "The number of hours of the monitor not reporting data before it will automatically resolve from a triggered state."
}

variable "metrics_monitor" {
  type = list(object({
    alert_name         = string
    type               = string
    message            = string
    # escalation_message = string
    query              = string
    # warning            = string
    # warning_recovery   = string
    critical           = string
    critical_recovery  = string
    priority           = number
    tags               = list(string)
  }))
  description = "metrics application configuration details"
}
