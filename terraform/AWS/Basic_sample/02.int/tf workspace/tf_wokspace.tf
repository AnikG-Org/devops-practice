provider "aws" {
  region     = "ap-south-1"
  access_key = "YOUR-ACCESS-KEY"
  secret_key = "YOUR-SECRET-KEY"
}

resource "aws_instance" "myec2" {
  ami           = "ami-xxxxxxxxx"
  instance_type = lookup(var.instance_type, terraform.workspace) #https://www.terraform.io/docs/configuration/functions/lookup.html
}

variable "instance_type" {
  type = "map"

  default = {
    default = "t2.nano" #workspace default
    dev     = "t2.micro"
    prd     = "t2.large"
  }
}