data "aws_ami" "al2_ami" {
  most_recent = true 
  owners = ["amazon"]
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
  owners = ["099720109477"]
  filter {
     name   = "architecture"
     values = ["x86_64"]
     }
  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-*"]
  }
}

output "ami" {
  value = zipmap(["al2_ami", "ubuntu_ami"], [data.aws_ami.ubuntu_ami.id , data.aws_ami.al2_ami.id])
}