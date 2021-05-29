
resource "aws_instance" "myec2" {
  ami = "ami-0bcf5425cdc1d8a85"
  availability_zone = "ap-south-1a"
  instance_type = "t3.micro"
  iam_instance_profile = aws_iam_instance_profile.myec2role_profile.name
  subnet_id = "subnet-08abb0bff7832cb37"
  key_name = "anik_test"
  tags = {
    Name = "myec2.id"
    created_from = "TF"
  }
}
resource "aws_eip" "lb" {
  vpc      = true
  tags = {
    Name = "myec2.eip"
    created_from = "TF"
  }
}

resource "aws_ebs_volume" "myec2ebs" {
  size   = 8
  availability_zone = "ap-south-1a"
  tags   = {
    Name = "myec2ebs"
    created_by = "TF"
  }
}


resource "aws_s3_bucket" "mys3" {
  bucket = "s3-attribute-demo-000001"
}
