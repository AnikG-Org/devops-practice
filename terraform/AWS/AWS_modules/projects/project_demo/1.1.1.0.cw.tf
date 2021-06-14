#/* #enable when required
######################################
# CWAlarm to create SP Managed alerms #
######################################
module "ar1_cpu_alarm" {
  source = "../../modules/0.1.7.monitoring/cloudwatch_alarm"


  alarm_count             = 0 #default 1
  alarm_description       = "High CPU Usage on AR1."
  name                    = "CPUAlarmHigh-AR1"
  sp_alarms_enabled       = true  #false by default
  customer_alarms_enabled = false #(OPTIONAL) #false by default
  comparison_operator     = "GreaterThanThreshold"
  evaluation_periods      = 10
  metric_name             = "CPUUtilization"
  namespace               = "AWS/EC2"
  #notification_topic      = [] #not required for sp_alarm 
  period    = 60
  severity  = "emergency"
  statistic = "Average"
  threshold = 90

  dimensions = [
    {
      InstanceId = "" #element(module.ec2_count_autorecovery.ec2_instance_id, 0)
    },
  ]
}

##############################
# CWAlarm to notify customer #
##############################
module "ar1_network_out_alarm" {
  source = "../../modules/0.1.7.monitoring/cloudwatch_alarm"


  alarm_count             = 0
  alarm_description       = "High Outbound Network traffic > 1MBps."
  name                    = "NetworkOutAlarmHigh-AR1"
  customer_alarms_enabled = true
  sp_alarms_enabled       = false #(OPTIONAL)
  comparison_operator     = "GreaterThanThreshold"
  evaluation_periods      = 10
  metric_name             = "NetworkOut"
  namespace               = "AWS/EC2"
  notification_topic      = [] # [module.customer_notifications.topic_arn[0]]
  period                  = 60
  statistic               = "Average"
  threshold               = 60000000

  dimensions = [
    {
      InstanceId = "" #element(module.ec2_count_autorecovery.ec2_instance_id, 0)
    },
  ]
}

########################################
# Create alarms for disk usage
########################################
# data "null_data_source" "alarm_dimensions" {
#   count = 1

#   inputs = {
#     InstanceId = element(module.ec2_count_autorecovery.ec2_instance_id, count.index)
#     device     = "/dev/sda1"
#     fstype     = "ext4"
#     path       = "/"
#   }
# }

module "ar1_disk_usage_alarm" {
  source = "../../modules/0.1.7.monitoring/cloudwatch_alarm"


  alarm_count         = 0
  alarm_description   = "High Disk usage."
  name                = "HighDiskUsageAlarm-AR2"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 30
  metric_name         = "disk_used_percent"
  namespace           = "System/Linux"
  period              = 60
  sp_alarms_enabled   = true
  severity            = "standard"
  statistic           = "Average"
  threshold           = 80

  dimensions = [
    {
      InstanceId = "" #module.ec2_count_autorecovery.ec2_instance_id[0]
    },
  ]
}

########################################
# Create alarms for vpn_status
########################################
module "vpn_status" {
  source = "../../modules/0.1.7.monitoring/cloudwatch_alarm"


  alarm_count             = 0
  alarm_description       = "VPN Connection State"
  alarm_name              = "VPN-Status"
  comparison_operator     = "LessThanOrEqualToThreshold"
  customer_alarms_enabled = true
  dimensions              = [{ VpnId = module.vgw.vpn_connection_id }]
  evaluation_periods      = 30
  metric_name             = "TunnelState"
  namespace               = "AWS/VPN"
  notification_topic      = [] # [module.customer_notifications.topic_arn[0]]
  period                  = 60
  sp_alarms_enabled       = false
  statistic               = "Maximum"
  threshold               = 0
}

module "client_vpn_status" {
  source = "../../modules/0.1.7.monitoring/cloudwatch_alarm"


  alarm_count             = 0
  alarm_description       = "C2S-VPN Connection State"
  alarm_name              = "S2S-VPN-Status"
  comparison_operator     = "LessThanOrEqualToThreshold"
  customer_alarms_enabled = true
  evaluation_periods      = 10
  metric_name             = "TunnelState"
  namespace               = "AWS/VPN"
  notification_topic      = module.customer_notifications.topic_arn
  period                  = 60
  sp_alarms_enabled       = false
  statistic               = "Maximum"
  threshold               = 0

  dimensions = [
    {
      VpnId = "" #module.client_vpn.aws_ec2_client_vpn_endpoint_id
    },
  ]
}
#*/
