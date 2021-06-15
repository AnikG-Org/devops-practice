variable "enable_task_definition" {
  default     = true
  description = "Registers a new task definition from the supplied family and containerDefinitions"
}
variable "container_definitions" {
  type    = list(any)
  default = []
}
variable "requires_compatibilities" {
  default     = ["EC2"]
  description = "(Optional) Set of launch types required by the task. The valid values are EC2 and FARGATE."
  type        = list(string)
}
variable "task_role_arn" {
  default     = ""
  description = "(Optional) ARN of IAM role that allows your Amazon ECS container task to make calls to other AWS services."
}
variable "execution_role_arn" {
  default     = ""
  description = "(Optional) The Amazon Resource Name (ARN) of the task execution role that the Amazon ECS container agent and the Docker daemon can assume"
}
variable "family" {
  description = "You must specify a family for a task definition, which allows you to track multiple versions of the same task definition"
  default     = {}
}
variable "ipc_mode" {
  default     = null
  description = "(Optional) IPC resource namespace to be used for the containers in the task The valid values are host, task, and none."
}
variable "network_mode" {
  default     = "bridge"
  description = "(Optional) Docker networking mode to use for the containers in the task. Valid values are none, bridge, awsvpc, and host."
}
variable "pid_mode" {
  default     = null
  description = " (Optional) Process namespace to use for the containers in the task. The valid values are host and task."
}
variable "cpu" {
  default     = null
  description = "The number of cpu units reserved for the container"
  type        = number
}
variable "memory" {
  default     = null
  description = "The hard limit (in MiB) of memory to present to the container.(Optional). If the requires_compatibilities is FARGATE this field is required."
  type        = number
}

variable "volumes" {
  default     = []
  description = "A list of volume definitions in JSON format that containers in your task may use"
  type        = list(any)
}
variable "proxy_configuration" {
  default     = []
  description = "proxy_configuration https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition#proxy_configuration"
  #type        = list(any)
  type = list(object({
    type           = string
    container_name = string
    properties     = list(any)
  }))
}
variable "placement_constraints" {
  default     = []
  description = "An array of placement constraint objects to use for the task"
  type = list(object({
    type       = string
    expression = string
  }))
}
variable "tags" {
  default     = {}
  description = "The metadata that you apply to the task definition to help you categorize and organize them"
  type        = map(string)
}