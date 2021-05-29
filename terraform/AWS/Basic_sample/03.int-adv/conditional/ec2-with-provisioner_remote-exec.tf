resource "aws_instance" "webapp" {
   ami = data.aws_ami.al2_ami.id       #from data spource
   instance_type = "t3.micro"
   key_name = var.instance_key
   count = 1
   subnet_id = "subnet-06343486e2168676d"
   associate_public_ip_address = true
   vpc_security_group_ids  = [aws_security_group.allow_ssh.id]
   tags = {
     Name = "webapp_provisioner-${count.index + 1}"
     App_Deployed_via = "provisioner"
   }

   provisioner "remote-exec" {          #for target machine
     on_failure = continue
     inline = [
       "echo provisioner remote-exec connection tested",
       #"sudo yum update -y",
       "sudo yum install httpd httpd-tools mod_ssl -y && sudo systemctl enable httpd && sudo systemctl start httpd",
       "sudo mkdir /var/www/html/home -p",
       "sudo echo '<html><body><div>Hello, world , this App_Deployed_via tf provisioner!</div></body></html>' > /var/www/html/home/index.html"
     ]
   }
   connection {
     type = "ssh"
     user = "ec2-user"
     private_key = file("./anik_test.pem")
     host = self.public_ip
   }
/*
   provisioner "remote-exec" {
       when    = destroy          #while doing tf destroy
       inline = [
         "sudo yum -y remove httpd httpd-tools mod_ssl"
       ]
     }

   provisioner "local-exec" {           #for local machine where you applying tf apply
    command = "echo ${aws_instance.webapp} >> ./private_ips.txt"
  }  
*/  
}
### NOTE - Adding a new security group resource to allow the terraform provisioner from laptop to connect to EC2 Instance via SSH.


resource "aws_security_group" "allow_ssh" {
    name = "dynamicsg-allow_ssh"
    description = "Ingress from internet for webserver"  
    revoke_rules_on_delete = true
    dynamic "ingress" {
        for_each = var.sg_ports_1
        iterator = ports
        
        content {
            from_port   = ports.value
            to_port     = ports.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]            
        }
    }
    egress {
      description = "Outbound Allowed"
      from_port   = 0
      to_port     = 65535
      protocol    = "all"
      cidr_blocks = ["0.0.0.0/0"]
  }    
}

variable "sg_ports_1" {
  type        = list(number)
  description = "list of ingress ports for SG"
  default     = [22,80]
}
