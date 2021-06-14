/* #  enable when required

module "budget_alerts" {
  source          = "../../modules/0.1.7.monitoring/aws-budget-alarms-slack"
  

  account_name             = "Demo-AWS-Testing"
  account_budget_limit     = 110
  create_slack_integration = false
  services = {
    Route53 = {
      budget_limit = 0.25
    },
    EC2 = {
      budget_limit = 50.25
    },
    S3 = {
      budget_limit = 12.35
    },
    ELB = {
      budget_limit = 11.0
    }
  }

  notifications = {
    warning = {
      comparison_operator = "GREATER_THAN"
      threshold           = 100
      threshold_type      = "PERCENTAGE"
      notification_type   = "ACTUAL"
    },
    critical = {
      comparison_operator = "GREATER_THAN"
      threshold           = 110
      threshold_type      = "PERCENTAGE"
      notification_type   = "ACTUAL"
    }
  }

  slack_workspace_id = "12345678910"
  slack_channel_id   = "12345678910"

  tags = {
    Account = "Testing"
  }
}

*/