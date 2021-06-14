locals {
  #enable_aws_volume_attachment = var.enable_aws_volume_attachment
}

resource "aws_ebs_volume" "ec2ebs_additional" {
  count  = var.ebs_count  

  availability_zone     = element(var.availability_zone, count.index)   #var.availability_zone
  size                  = var.volume_size
  type                  = var.volume_type

  snapshot_id           = var.snapshot_id
  iops                  = var.iops
  multi_attach_enabled  = var.multi_attach_enabled
  throughput            = var.throughput
  encrypted             = var.encryption
  kms_key_id            = var.kms_key_id

  tags = merge(
    var.additional_tags,
    {
      Name              = "${var.ebstagname}-${count.index + 001}"
      ebs_sequence      = count.index + 001
      Environment     = var.environment
      Created_Via     = "Terraform IAAC"
      Project         = var.project
      SCM             = var.git_repo
      ServiceProvider = var.ServiceProvider
    },
    var.tags
  )
  lifecycle {
    ignore_changes = [tags.timestamp]
  }

}
resource "aws_volume_attachment" "ebs_attachment" {
  count                       = var.enable_aws_volume_attachment ? var.ebs_count : 0
  device_name                 = element(var.device_name, count.index)
  volume_id                   = element(aws_ebs_volume.ec2ebs_additional.*.id, count.index)
  instance_id                 = element(var.instance_id[*], count.index)

  depends_on = [var.ebs_attachment_depends_on]
}

######################## VARIABLE ###############################
variable "ebs_count" {
  description = "Number of EBS Volume to launch"
  type        = number
  default     = 1
}
variable "enable_aws_volume_attachment" {
  type    = bool
  default = false
}
variable "availability_zone" {
  description = "Additional EBS block devices availability_zones"
  type        = list(string)
  default     = ["us-east-1a","us-east-1b", "us-east-1c"] #["ap-south-1a" , "ap-south-1b", "ap-south-1c"]
}
variable "multi_attach_enabled" {
  type    = bool
  default = false
}
variable "snapshot_id" { default = "" }
variable "volume_type" { default = "gp3" }
variable "volume_size" {
  type    = number
  default = 1
}
variable "iops" {
  type    = number
  default = null
}
variable "throughput" {
  type    = number
  default = null
}
variable "encryption" {
  type    = bool
  default = false
}
variable "kms_key_id" { default = "" }
#attachment vars
variable "device_name" {
  type     = list(string)
  default = ["/dev/sdf","/dev/sdb", "/dev/sdd", "/dev/sde","/dev/sda2", "/dev/sda1", "/dev/sdh", "xvdf"] #"xvdf" for windows
}
variable "instance_id" {
  description = "Additional EBS block devices will attach to instance_id"
  type        = list(string)
  #default     = []
}
variable "ebs_attachment_depends_on" {
  type = any
  default = []
}

#TAGs
variable "ebstagname" { default = "ebs" }
variable "additional_tags" {
  default     = {}
  description = "Additional resource tags"
  type        = map(string)
}
