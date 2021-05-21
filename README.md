# devops-practice
Practice

# Docker-jenkins-practice

1. Docker / Docker compose/ Jenkins - Groovy pipeline

Path: devops-practice/docker/*   devops-practice/jenkins/*   devops-practice/maven/* [for jenkins test build]

Required packages: 
#!/bin/bash

yum update -y
yum install git -y
yum install java-1.8.0 -y
yum install docker -y
yum install maven -y
sudo curl -L "https://github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo ln -s /usr/local/bin/docker-compose /usr/bin/docker-compose


#maven test project: https://maven.apache.org/guides/getting-started/maven-in-five-minutes.html



# kubernetes-practice
2. #kubernetes CKA + advanced  practice manifist files added which i used to note for all situations while study those , it can re usable based on inputs and customization.

path: devops-practice/kubernetes/*


# Terraform-practice (Upcoming)

path: devops-practice/terraform/*



-@nik
