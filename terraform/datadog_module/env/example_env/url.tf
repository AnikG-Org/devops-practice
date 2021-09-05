module "dal_url_lower" {
  source = "././datadog_module/synthetic-url"
  service_urls = [
    {
      locations = [""]
      name      = "Alert1"
      app_url   = "https://url"
      status    = "paused"
      message   = " {{#is_alert}} Endpoint has been unresponsive for more than 5m .  {{/is_alert}} \n Notify:  "
      tags      = ["priority:3" ,"pwc_severity:3"]
    }
  ]
}
