#!/bin/bash

echo "Hello Terraform! $(date +'%d/%m/%Y')"
yum update -y
amazon-linux-extras install nginx1 -y
systemctl enable nginx
systemctl start nginx