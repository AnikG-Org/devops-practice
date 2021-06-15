locals {
  role_arn = var.role_arn == "" ? aws_iam_role.pipeline.0.arn : var.role_arn
}
resource "aws_codepipeline" "pipe" {
  artifact_store {
    location = var.artifact_store["location"]
    type     = var.artifact_store["type"]
    #encryption_key = var.artifact_store["encryption_key"]
  }

  name     = var.name
  role_arn = local.role_arn


  dynamic "stage" {
    for_each = [for s in var.stages : {
      name   = s.name
      action = s.action
    } if(lookup(s, "enabled", true))]

    content {
      name = stage.value.name
      action {
        name             = stage.value.action["name"]
        owner            = stage.value.action["owner"]
        version          = stage.value.action["version"]
        category         = stage.value.action["category"]
        provider         = stage.value.action["provider"]
        input_artifacts  = lookup(stage.value.action, "input_artifacts", [])
        output_artifacts = lookup(stage.value.action, "output_artifacts", [])
        configuration    = lookup(stage.value.action, "configuration", {})
        role_arn         = lookup(stage.value.action, "role_arn", null)
        run_order        = lookup(stage.value.action, "run_order", null)
        region           = lookup(stage.value.action, "region", data.aws_region.current.name)
      }
    }
  }

  tags = merge(
    {
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
}
# locals {
#   webhook_secret = join("", random_string.webhook_secret.*.result)
#   webhook_url    = join("", aws_codepipeline_webhook.webhook.*.url)
# }
# resource "aws_codepipeline_webhook" "webhook" {
#   count           = module.this.enabled && var.webhook_enabled ? 1 : 0
#   name            = module.codepipeline_label.id
#   authentication  = var.webhook_authentication
#   target_action   = var.webhook_target_action
#   target_pipeline = join("", aws_codepipeline.default.*.name)

#   authentication_configuration {
#     secret_token = local.webhook_secret
#   }

#   filter {
#     json_path    = var.webhook_filter_json_path
#     match_equals = var.webhook_filter_match_equals
#   }
# }