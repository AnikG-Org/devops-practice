# Create a new Datadog Synthetics API/HTTP test on https://www.example.org
resource "datadog_synthetics_test" "Synthetictest" {
  count   = (var.service_urls != null) ? length(var.service_urls) : 0
  type    = var.test_type
  subtype = var.test_subtype
  request_definition {
    method = var.test_method
    url    = var.service_urls[count.index]["app_url"]
  }
  assertion {
    type     = "statusCode"
    operator = "is"
    target   = "200"
  }
  locations = var.service_urls[count.index]["locations"]

  options_list {
    tick_every         = var.tick_interval
    follow_redirects   = var.follow_redirects
    accept_self_signed = var.accept_self_signed
    # monitor_priority   = var.service_urls[count.index]["priority"]   #this feature is available from 3.1 onwards
    # monitor_name       = var.service_urls[count.index]["name"]

    retry {
      count    = var.retry_count
      interval = var.retry_interval
      }
    monitor_options {
      renotify_interval = var.renotify_interval
    } 
  }  

  name      = var.service_urls[count.index]["name"]
  message   = var.service_urls[count.index]["message"]
  tags      = var.service_urls[count.index]["tags"]
  status    = var.service_urls[count.index]["status"]
}

########################################
############### VAR ####################

variable "follow_redirects" {
  type        = bool
  default     = true
  description = "For API HTTP test, whether or not the test should follow redirects."
}

variable "accept_self_signed" {
  type        = bool
  default     = true
  description = "For SSL test, whether or not the test should allow self signed certificates."
}

variable "test_type" {
  description = "Type of synthetic test"
  default     = "api"
}

variable "test_subtype" {
  description = "Subtype of synthetic test"
  default     = "http"
}

variable "test_method" {
  description = "Calling Method type of synthetic test"
  type        = string
  default     = "GET"
}

variable "tick_interval" {
  description = "ping time interval "
  type        = string
  default     = "300"
}

variable "retry_count" {
  description = "retry "
  type        = string
  default     = "2"
}

variable "retry_interval" {
  description = "retry interval "
  type        = string
  default     = "300"
}

variable "renotify_interval" {
  description = "Specify a renotification frequency"
  type        = number
  default     = 180
}

variable "service_urls" {
    type  = list(object({
        locations = list(string)
        name     = string
        app_url  = string
        status   = string
        message  = string
        # priority = number
        tags     = list(string)
    }))
    description = "Synthetic test application configuration details"
}
