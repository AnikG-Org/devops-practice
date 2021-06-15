variable "enable_service" {
  type    = bool
  default = true
}
variable "service_name" {
  type    = string
  default = ""
}
variable "task_definition" {
  type    = string
  default = ""
}
variable "cluster" {
  type    = string
  default = ""
}
variable "desired_count" {
  type        = number
  default     = 0
  description = "(Optional) Number of instances of the task definition to place and keep running. Defaults to 0. Do not specify if using the DAEMON scheduling strategy."
}
variable "iam_role" {
  type        = string
  default     = ""
  description = "(Optional) ARN of the IAM role that allows Amazon ECS to make calls to your load balancer on your behalf. This parameter is required if you are using a load balancer with your service, but only if your task definition does not use the awsvpc network mode. If using awsvpc network mode, do not specify this role. If your account has already created the Amazon ECS service-linked role, that role is used by default for your service unless you specify a role here."
}
variable "scheduling_strategy" {
  description = "(Optional) Scheduling strategy to use for the service. The valid values are REPLICA and DAEMON. Defaults to REPLICA. Note that Tasks using the Fargate launch type or the CODE_DEPLOY or EXTERNAL deployment controller types don't support the DAEMON scheduling strategy."
  default     = "REPLICA"
}
variable "deployment_maximum_percent" {
  description = "(Optional) Upper limit (as a percentage of the service's desiredCount) of the number of running tasks that can be running in a service during a deployment. Not valid when using the DAEMON scheduling strategy."
  type        = number
  default     = 200
}
variable "deployment_minimum_healthy_percent" {
  description = " (Optional) Lower limit (as a percentage of the service's desiredCount) of the number of running tasks that must remain running and healthy in a service during a deployment."
  type        = number
  default     = 100
}
variable "deployment_circuit_breaker" {
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#deployment_circuit_breaker"
  type        = list(any)
  default     = []
}
variable "ordered_placement_strategy" {
  type        = list(any)
  default     = []
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#ordered_placement_strategy"
}
variable "network_configuration" {
  type        = list(any)
  default     = []
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#network_configuration"
}
variable "health_check_grace_period_seconds" {
  default     = null
  description = "(Optional) Seconds to ignore failing load balancer health checks on newly instantiated tasks to prevent premature shutdown, up to 2147483647. Only valid for services configured to use load balancers."
}
variable "load_balancer" {
  type        = list(any)
  default     = []
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#load_balancer"
}
variable "placement_constraints" {
  type        = list(any)
  default     = []
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#placement_constraints"
}
variable "deployment_controller" {
  type = list(object({
    type = string
  }))
  default     = []
  description = "https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service#deployment_controller"
}