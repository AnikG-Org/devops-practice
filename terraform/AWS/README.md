# Terraform-Module for AWS
path: devops-practice/terraform/AWS/AWS_modules/modules/*

[![Terraform](https://img.shields.io/badge/Terraform-%235849a6.svg)](https://registry.terraform.io/)

*** terraform AWS Module Version support  ***
-----
<p align="left">
terraform {
  required_version = "~> 0.13"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.40"
    }
  } 
}
</p> 
-----




# Terraform-Module - AWS

[![Detailed Terraform use case here](https://img.shields.io/badge/IAAC%20with-Terraform-%235849a6.svg)](https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/tf-module-use-case-doc-v1.pdf)

•	Link to AWS TF_Modules files & directory list:  https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/TF_Modules_directory_list.txt

•	Terraform-Module - AWS: https://github.com/AnikG-Org/devops-practice/tree/main/terraform/AWS/AWS_modules/modules

Most of common used AWS services / resources including automation service covered. : [![Module EXAMPLEs](https://img.shields.io/badge/Module%20EXAMPLEs%20-Terraform-%235849a6.svg)](https://github.com/AnikG-Org/devops-practice/tree/main/terraform/AWS/AWS_modules/projects/project_demo) 


•	My Terraform Cheat cmds and notes , That might handy for everyone : https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/cmd.sh

**Maximum module prepared by myself and maximum are tested and applied at Module EXAMPLE: "project_demo" . [![Open Source Love](https://badges.frapsoft.com/os/v2/open-source.svg?v=103)](https://github.com/AnikG-Org)



# Terraform-Project - "project_demo" using "Terraform-Module' - AWS


Link: Module EXAMPLE:
      https://github.com/AnikG-Org/devops-practice/tree/main/terraform/AWS/AWS_modules/projects/project_demo
      
Note: Most of the components has count = 0 / /* <new line> */ or Disabled . enable it and use it  
  
  
# Detailed Overview on AWS Module and - "project_demo" usage' - AWS TF
 
<p align="center">
Follow the Link >>  https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/tf-module-use-case-doc-v1.pdf
</p>  

# Project WorkFlow TF CI-CD  AWS deployment

<p align="center">
  <img src="https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/Untitled%20Diagram.png" width="814" height="420" />
</p>

**WorkFlow** : GIT , TF, TF cloud(Free tier), TF modules, Project to deploy resource (Provider AWS), CI/CD: Jenkins(Runtime Docker,Jenkins Hosting: EC2),EC2-IAM-ROLE for AWS-Service-API, CI-CD JOB: groovy scripted pipeline with business logic, AWS Cloud deployment.


•	Used Terraform-Module - AWS: https://github.com/AnikG-Org/devops-practice/tree/main/terraform/AWS/AWS_modules/modules

•	Deployed "project_demo" resources using TF modules: https://github.com/AnikG-Org/devops-practice/tree/main/terraform/AWS/AWS_modules/projects/project_demo  [![Module EXAMPLEs](https://img.shields.io/badge/Module%20EXAMPLEs%20-Terraform-%235849a6.svg)](https://github.com/AnikG-Org/devops-practice/tree/main/terraform/AWS/AWS_modules/projects/project_demo) 


•	Jenkins setup on Docker: https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/jenkins-pipeline-for-tf-deploy/Jenkins%20setup.txt

•	Jenkins_PipeLine: https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/jenkins-pipeline-for-tf-deploy/jenkinsfile

  
      
<p align="center">
  <img src="https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/jenkins-pipeline-for-tf-deploy/IMG_20210616_214150.jpg" width="814" height="820" />
</p>      

## TF CLOUD  <https://app.terraform.io/>

<p align="center">
  <img src="https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/tf-cloud.JPG" width="814" height="300" />
</p> 

<p align="center">
  <img src="https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/tf-cloud-1.JPG" width="814" height="300" />
</p> 

*** terraform workspace select prod ***
    workspaces { 
      prefix = "project-demo-"
    }

•	Basic sentinel-policy for TF cloud:  https://github.com/AnikG-Org/devops-practice/tree/main/terraform/AWS/AWS_modules/sentinel-policy
  
•	gitignore file for TF:  https://github.com/AnikG-Org/devops-practice/blob/main/terraform/AWS/AWS_modules/projects/project_demo/.gitignore  


# Terraform sample basic independent code:

•	link to go: https://github.com/AnikG-Org/devops-practice/tree/main/terraform/AWS/Basic_sample

---------------------------------------------------------------------------------------------------------------------------

Note: Some of modules/referance features taken from open TF registry for hands on practice and made those my own based on my requirement.

Anyone can fork and use this modules. I made this TF Open Source. Happy learing .      
[![LICENSE](https://img.shields.io/badge/LICENSE%20Open%20source-Terraform-%235849a6.svg)](https://github.com/AnikG-Org/devops-practice/blob/main/terraform/LICENSE)      
      
Connect me: 

[![Connect my profile](https://img.shields.io/badge/Anik_Guha-%E34F26?style=flat-square&logo=amazon-aws&logoColor=orange)](https://github.com/AnikG-Org/AnikG-Org/blob/main/README.md)
