#common var
variable "instance_count_sequence" { default = "1" }

#providor
variable "region" { default = "ap-south-1" }
variable "access_key" {}
variable "secret_key" {}
variable "token" {}
#EC2 variable
variable "myec2_instancetype" {}

variable "myec2ami" {
  type = map
  default = {
    ap-south-1 = "ami-0bcf5425cdc1d8a85" #al2
  }
}
variable "myec2_vpc_id" { default = "vpc-002a0df2fc12ee47a" }
variable "myec2_subnet_id" { default = "subnet-08abb0bff7832cb37" }
variable "instance_key" {}
variable "ec2_az" { default = "ap-south-1a" }
#Autoscale ec2
variable "ec2_autoscale_az" {
  type    = list
  default = ["ap-south-1a", "ap-south-1b"]
}
#ELB
variable "elb_pub_subnet" {
  type    = list
  default = ["subnet-08abb0bff7832cb37", "subnet-04460d20f59cdb04b"]
}

variable "pvt_subnet" {
  type    = list
  default = ["subnet-0df9cf901bf5a8681", "subnet-0721d479da6489ab0"]
}

#storage
variable "root_block_device_type" { default = "gp3" }
variable "root_block_device_size" { default = "8" }
variable "root_block_device_encryption" { default = "false" }
variable "root_block_device_delete_on_termination" { default = "true" }

variable "mys3_log_bucket_name" { default = "s3-tf-attribute-log-000002" }
#tag_variable

variable "myec2tagname" {
  type = map
  default = {
    Name       = "myec2"
    created_by = "anik"
  }
}

#Security
variable "myec2sgcidr" {
  type    = list
  default = ["0.0.0.0/0"]
}