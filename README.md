# devops-practice
Practice
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

 @nik
