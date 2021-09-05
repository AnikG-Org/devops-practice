module "linux_vm_alert" {
  source = "././datadog_module/metric-monitor"
  include_tags = false
  metrics_monitor = [
    {
      alert_name = "Linux VM {{host.name}} {{env_.name}} High CPU Load Exceeds 90 Percent"
      type       = "metric alert"
      query      = "avg(last_5m):avg:system.cpu.user{*} by {*} >=90"
      message    = "{{#is_alert}} {{host.name}} {{env_.name}} . Virtual Machine host high CPU load for instance . CPU load is >  {{threshold}}  {{/is_alert}} . \n {{#is_recovery}} {{host.name}} Virtual Machine host high CPU load Alert Solved  {{/is_recovery}} \n Notify:  "
      # escalation_message = string
      # warning           = 85
      # warning_recovery  = 84
      critical          = 90
      critical_recovery = 89
      priority          = 3
      tags      = ["severity:3"]
    }
  ]
}
