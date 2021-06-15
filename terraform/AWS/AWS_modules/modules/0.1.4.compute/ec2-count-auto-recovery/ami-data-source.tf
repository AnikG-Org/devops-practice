
data "aws_ami" "al2_ami" {
  most_recent = true
  owners      = ["amazon"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["amzn2-ami-hvm*"]
  }
}

data "aws_ami" "ubuntu_ami" {
  most_recent = true
  owners      = ["099720109477"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*"]
  }
}

data "aws_ami" "redhat_ami" {
  most_recent = true
  owners      = ["309956199498"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["RHEL-*"]
  }
}

data "aws_ami" "sles_ami" {
  most_recent = true
  owners      = ["013907871322"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["suse-sles-sap-*"]
  }
}

data "aws_ami" "centos_ami" {
  most_recent = true
  owners      = ["125523088429"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["CentOS 8.* x86_64*"]
  }
}

data "aws_ami" "Windows_Server_base_2019_ami" {
  most_recent = true
  owners      = ["801119661308"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["Windows_Server-2019-English-Full-Base-*"]
  }
}

data "aws_ami" "Windows_Server_base_2016_ami" {
  most_recent = true
  owners      = ["801119661308"]
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
  filter {
    name   = "name"
    values = ["Windows_Server-2016-English-Full-Base-*"]
  }
}
############# Latest AMI #############
output "ami_linux" {
  value = zipmap(["al2_ami", "ubuntu_ami", "redhat_ami", "sles_ami", "centos_ami"], [data.aws_ami.al2_ami.id, data.aws_ami.ubuntu_ami.id, data.aws_ami.redhat_ami.id, data.aws_ami.sles_ami.id, data.aws_ami.centos_ami.id])
}
output "ami_windows" {
  value = zipmap(["Windows_Server_base_2016_ami", "Windows_Server_base_2019_ami"], [data.aws_ami.Windows_Server_base_2016_ami.id, data.aws_ami.Windows_Server_base_2019_ami.id])
}
######################################