################################################################################
locals {
  tags = concat(
    [
      {
        "key"                 = "Name"
        "value"               = var.asg_instance_name
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Project"
        "value"               = var.project
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Environment"
        "value"               = var.environment
        "propagate_at_launch" = true
      },
      {
        "key"                 = "Created_Via"
        "value"               = "Terraform IAAC"
        "propagate_at_launch" = true
      },
      # {
      #   "key"                 = "timestamp"
      #   "value"               = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp()))
      #   "propagate_at_launch" = true
      # },
      {
        "key"                 = "SCM"
        "value"               = var.git_repo
        "propagate_at_launch" = true
      },
      {
        "key"                 = "ServiceProvider"
        "value"               = var.ServiceProvider
        "propagate_at_launch" = true
      },

    ],
    var.tags,
    null_resource.tags_as_list_of_maps.*.triggers,
  )
  #for LT tag
  tags_as_map = merge(
    var.additional_tags,
    {
      Name            = var.lt_name,
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
      #timestamp   = format("Created or Modified Date: %s", formatdate("MM/DD/YYYY", timestamp())),
    },
  )

  #   tag_specifications = [
  #     {
  #       resource_type = "instance"
  #       tags          = merge({ WhatAmI = "Instance" }, local.tags_as_map)
  #     },
  #     {
  #       resource_type = "volume"
  #       tags          = merge({ WhatAmI = "Volume" }, local.tags_as_map)
  #     },
  #     # {
  #     #   resource_type = "spot-instances-request"
  #     #   tags          = merge({ WhatAmI = "SpotInstanceRequest" }, local.tags_as_map)
  #     # },
  #   ]
  #   default_tag_specifications = merge(var.tag_specifications, local.tag_specifications)    #marging LT variable{tag_specifications} default value with local{tag_specifications}

}

resource "null_resource" "tags_as_list_of_maps" {
  count = length(keys(var.tags_as_map))

  triggers = {
    "key"                 = keys(var.tags_as_map)[count.index]
    "value"               = values(var.tags_as_map)[count.index]
    "propagate_at_launch" = true
  }
}


################################################################################
#   COMMON VAR
################################################################################

variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
variable "tags_as_map" {
  description = "A map of tags and values in the same format as other resources accept. This will be converted into the non-standard format that the aws_autoscaling_group requires."
  type        = map(string)
  default     = {}
}