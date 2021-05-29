#!/bin/bash

echo "Hello Terraform! $(date +'%d/%m/%Y')"
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
systemctl status httpd
mkdir /var/www/html/home -p
echo "<html><body><div>Hello, world!</div></body></html>" > /var/www/html/home/index.html