variable "application_name" {
  description = "CodeDeploy Application Name.  If an existing Application is being associated, 'create_application' should be set to false"
  type        = string
}

variable "autoscaling_groups" {
  description = "A List of Autoscaling Group names to associate with the Deployment Group"
  default     = []
  type        = list(string)
}

variable "clb_name" {
  description = "The name of the CLB to associate with this Deployment Group.  If associated, the instances will be taken out of service while the application is deployed.   This variable cannot be used in conjunction with target_group_name."
  type        = string
  default     = ""
}

variable "create_application" {
  description = "Boolean variable controlling if a new CodeDeploy application should be created."
  default     = true
  type        = bool
}
variable "compute_platform" { default = "Server" } # (Optional) The compute platform can either be ECS, Lambda, or Server. Default is Server
variable "deployment_config_name" {
  description = "CodeDeploy Deployment Config Name to use as the default for this Deployment Group.  Valid values include 'CodeDeployDefault.OneAtATime', 'CodeDeployDefault.HalfAtATime', and 'CodeDeployDefault.AllAtOnce'"
  default     = "CodeDeployDefault.OneAtATime"
  type        = string
}

variable "deployment_group_name" {
  description = "CodeDeploy Deployment Group Name.  If omitted, name will be based on Application Group and Environment"
  default     = ""
  type        = string
}
variable "enable_auto_rollback_configuration" {
  default = true
  type    = bool
}
variable "enable_bluegreen" {
  default = false
  type    = bool
}
variable "bluegreen_timeout_action" {
  description = "When to reroute traffic from an original environment to a replacement environment. Only relevant when `enable_bluegreen` is `true`"
  type        = string
  default     = "CONTINUE_DEPLOYMENT"
}
variable "wait_time_in_minutes" {
  default     = 0
  type        = string
  description = "The number of minutes to wait before the status of a blue/green deployment changed to Stopped if rerouting is not started manually."
}
variable "blue_termination_behavior" {
  description = " The action to take on instances in the original environment after a successful deployment. Only relevant when `enable_bluegreen` is `true`"
  default     = "KEEP_ALIVE"
}
variable "green_provisioning" {
  description = "The method used to add instances to a replacement environment. Only relevant when `enable_bluegreen` is `true`"
  type        = string
  default     = "COPY_AUTO_SCALING_GROUP"
}
variable "termination_wait_time_in_minutes" {
  default     = 5
  type        = string
  description = "The number of minutes to wait after a successful blue/green deployment before terminating instances from the original environment."
}
variable "trigger_target_arn" {
  description = "The ARN of the SNS topic through which notifications are sent"
  type        = string
  default     = null
}
variable "trigger_events" {
  description = "events that can trigger the notifications"
  type        = list(string)
  default     = ["DeploymentStop", "DeploymentRollback", "DeploymentSuccess", "DeploymentFailure", "DeploymentStart"]
}

variable "cluster_name" { default = null }
variable "service_name" { default = null }
variable "ec2_tag_key" {
  description = "Tag key for the Deployment Groups EC2 Tag Filter.  If omitted, no EC2 Tag Filter will be applied."
  default     = ""
  type        = string
}

variable "ec2_tag_value" {
  description = "Tag value for the Deployment Groups EC2 Tag Filter."
  default     = ""
  type        = string
}

variable "deployment_environment" {
  description = "Application environment for which this infrastructure is being created. e.g. Development/Production."
  default     = "Production"
  type        = string
}

variable "target_group_name" {
  description = "The name of the Target Group to associate with this Deployment Group.  If associated, the instances will be taken out of service while the application is deployed.  This variable cannot be used in conjunction with clb_name."
  default     = ""
  type        = string
}
#######################################
variable "lb_listener_arns" {
  type        = list(string)
  default     = []
  description = "List of Amazon Resource Names (ARNs) of the load balancer listeners."
}
variable "test_traffic_route" {
  default = false
  type    = bool
}
variable "test_traffic_route_listener_arns" {
  default     = null
  type        = list(string)
  description = "#(OPTIONAL) List of Amazon Resource Names (ARNs) of the load balancer to route test traffic listeners."
}
variable "blue_lb_target_group_name" {
  type        = string
  default     = ""
  description = "Name of the blue target group."
}
variable "green_lb_target_group_name" {
  type        = string
  default     = ""
  description = "Name of the green target group."
}