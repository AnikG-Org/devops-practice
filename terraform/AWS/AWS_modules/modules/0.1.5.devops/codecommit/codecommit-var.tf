variable "default_branch" {
  description = "The default branch for the repository"
  type        = string
  default     = "main"
}

variable "description" {
  description = "A description of the repository"
  type        = string
  default     = ""
}

variable "enable_trigger_1" {
  description = "Enable trigger #1 for the repository"
  type        = bool
  default     = false
}

variable "enable_trigger_2" {
  description = "Enable trigger #2 for the repository"
  type        = bool
  default     = false
}

variable "enable_trigger_3" {
  description = "Enable trigger #3 for the repository"
  type        = bool
  default     = false
}

variable "enable_trigger_4" {
  description = "Enable trigger #4 for the repository"
  type        = bool
  default     = false
}

variable "name" {
  description = "Name of the repository. `name` supercedes the deprecated `repository_name`. Either `name` or `repository_name` **must** contain a non-default value."
  type        = string
  default     = ""
}

variable "repository_name" {
  description = "Name of the repository.[**Deprecated** in favor of `name`]. It will be removed in future releases. `name` supercedes the `repository_name`. Either `name` or `repository_name` **must** contain a non-default value."
  type        = string
  default     = ""
}

variable "trigger_1_branches" {
  description = "The branches that will be included in the trigger configuration. If no branches are specified, the trigger will apply to all branches."
  type        = list(string)
  default     = []
}

variable "trigger_1_custom_data" {
  description = "Any custom data associated with the trigger that will be included in the information sent to the target of the trigger."
  type        = string
  default     = ""
}

variable "trigger_1_destination_arn" {
  description = "The ARN of the resource that is the target for a trigger. For example, the ARN of a topic in Amazon Simple Notification Service (SNS)."
  type        = string
  default     = ""
}

variable "trigger_1_events" {
  description = "The repository events that will cause the trigger to run actions in another service. Event types include: all, updateReference, createReference, deleteReference."
  type        = list(string)
  default     = []
}

variable "trigger_1_name" {
  description = "Trigger #1 name"
  type        = string
  default     = ""
}


variable "trigger_2_branches" {
  description = "The branches that will be included in the trigger configuration. If no branches are specified, the trigger will apply to all branches."
  type        = list(string)
  default     = []
}

variable "trigger_2_custom_data" {
  description = "Any custom data associated with the trigger that will be included in the information sent to the target of the trigger."
  type        = string
  default     = ""
}

variable "trigger_2_destination_arn" {
  description = "The ARN of the resource that is the target for a trigger. For example, the ARN of a topic in Amazon Simple Notification Service (SNS)."
  type        = string
  default     = ""
}

variable "trigger_2_events" {
  description = "The repository events that will cause the trigger to run actions in another service. Event types include: all, updateReference, createReference, deleteReference."
  type        = list(string)
  default     = []
}

variable "trigger_2_name" {
  description = "Trigger #2 name"
  type        = string
  default     = ""
}

variable "trigger_3_branches" {
  description = "The branches that will be included in the trigger configuration. If no branches are specified, the trigger will apply to all branches."
  type        = list(string)
  default     = []
}

variable "trigger_3_custom_data" {
  description = "Any custom data associated with the trigger that will be included in the information sent to the target of the trigger."
  type        = string
  default     = ""
}

variable "trigger_3_destination_arn" {
  description = "The ARN of the resource that is the target for a trigger. For example, the ARN of a topic in Amazon Simple Notification Service (SNS)."
  type        = string
  default     = ""
}

variable "trigger_3_events" {
  description = "The repository events that will cause the trigger to run actions in another service. Event types include: all, updateReference, createReference, deleteReference."
  type        = list(string)
  default     = []
}

variable "trigger_3_name" {
  description = "Trigger #3 name"
  type        = string
  default     = ""
}

variable "trigger_4_branches" {
  description = "The branches that will be included in the trigger configuration. If no branches are specified, the trigger will apply to all branches."
  type        = list(string)
  default     = []
}

variable "trigger_4_custom_data" {
  description = "Any custom data associated with the trigger that will be included in the information sent to the target of the trigger."
  type        = string
  default     = ""
}

variable "trigger_4_destination_arn" {
  description = "The ARN of the resource that is the target for a trigger. For example, the ARN of a topic in Amazon Simple Notification Service (SNS)."
  type        = string
  default     = ""
}

variable "trigger_4_events" {
  description = "The repository events that will cause the trigger to run actions in another service. Event types include: all, updateReference, createReference, deleteReference."
  type        = list(string)
  default     = []
}

variable "trigger_4_name" {
  description = "Trigger #4 name"
  type        = string
  default     = ""
}