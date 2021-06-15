variable "is_prod" {} #for condition
variable "is_dev" {}
variable "is_stg" {}

locals { #for localvalue
  common_tags = {
    Owner   = "DevOps Team"
    service = "backend"
  }
  time = formatdate("DD MMM YYYY hh:mm ZZZ", timestamp()) #function timestamp
}
#TF functions https://www.terraform.io/docs/language/functions/index.html
variable "region" {
  default = "ap-south-1"
}
variable "tags" {
  type    = list
  default = ["first_stg_ec2", "second_stg_ec2"]
}

variable "ami" {
  type = map
  default = {
    "us-east-1"  = "ami-0323c3dd2da7fb37d"
    "us-west-2"  = "ami-0d6621c01e8c2de2c"
    "ap-south-1" = "ami-0bcf5425cdc1d8a85"
  }
}

#---------------------------------------------------------------------------

resource "aws_instance" "dev" {
  ami           = lookup(var.ami, var.region) #function lookup
  instance_type = "t2.micro"
  count         = var.is_prod == false ? var.dev_count : 0     #conditional
  user_data     = filebase64("${path.module}/asg_userdata.sh") #function filebase64
  tags = merge(
    local.common_tags,
    map(
      "Name", "dev-server-${count.index + 1}"
    )
  ) #local
}

resource "aws_instance" "prod" {
  ami           = lookup(var.ami, var.region)
  instance_type = "t2.large"
  count         = var.is_prod == true ? var.prod_count : 0
  user_data     = filebase64("${path.module}/asg_userdata.sh")
  tags          = local.common_tags
}

resource "aws_instance" "stg" {
  ami           = data.aws_ami.ubuntu_ami.id #from data spource
  instance_type = "t2.micro"
  count         = var.is_stg == true ? var.stg_count : 0

  tags = {
    Name = element(var.tags, count.index) #function element
  }
}

#---------------------------------------------------------------------------
output "timestamp" {
  value = local.time
}