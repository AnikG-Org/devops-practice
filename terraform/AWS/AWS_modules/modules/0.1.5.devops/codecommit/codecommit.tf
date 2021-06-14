locals {
  repo_name = var.name != "" ? var.name : var.repository_name

}

resource "aws_codecommit_repository" "repo" {
  repository_name = local.repo_name
  description     = var.description
  default_branch  = var.default_branch
}

resource "aws_codecommit_trigger" "trigger_1" {
  count = var.enable_trigger_1 ? 1 : 0

  repository_name = local.repo_name

  trigger {
    branches        = var.trigger_1_branches
    custom_data     = var.trigger_1_custom_data
    destination_arn = var.trigger_1_destination_arn
    events          = var.trigger_1_events
    name            = var.trigger_1_name
  }

  depends_on = [aws_codecommit_repository.repo]
}


resource "aws_codecommit_trigger" "trigger_2" {
  count = var.enable_trigger_2 ? 1 : 0

  repository_name = local.repo_name

  trigger {
    branches        = var.trigger_2_branches
    custom_data     = var.trigger_2_custom_data
    destination_arn = var.trigger_2_destination_arn
    events          = var.trigger_2_events
    name            = var.trigger_2_name
  }

  depends_on = [aws_codecommit_repository.repo]
}

resource "aws_codecommit_trigger" "trigger_3" {
  count = var.enable_trigger_3 ? 1 : 0

  repository_name = local.repo_name

  trigger {
    branches        = var.trigger_3_branches
    custom_data     = var.trigger_3_custom_data
    destination_arn = var.trigger_3_destination_arn
    events          = var.trigger_3_events
    name            = var.trigger_3_name
  }

  depends_on = [aws_codecommit_repository.repo]
}

resource "aws_codecommit_trigger" "trigger_4" {
  count = var.enable_trigger_4 ? 1 : 0

  repository_name = local.repo_name

  trigger {
    branches        = var.trigger_4_branches
    custom_data     = var.trigger_4_custom_data
    destination_arn = var.trigger_4_destination_arn
    events          = var.trigger_4_events
    name            = var.trigger_4_name
  }

  depends_on = [aws_codecommit_repository.repo]
}