################### Remote state TF cloud #############
##manage from project_demo 
terraform {
  required_version = "~> 0.13"
  backend "remote" {
    hostname     = "app.terraform.io"
    organization = "AnikG-Org"

    workspaces {
      #name = "project-demo"  
      prefix = "project-demo-"
    }
  }
}



# credentials "app.terraform.io" {
#   token = "xxxxxx.atlasv1.zzzzzzzzzzzzz"
# }

#workspaces.Prefix: workspace name "${terraform.workspace}" >(e.g. dev, test) that will be used to migrate the existing default workspace.
#############################################
data "terraform_remote_state" "tfe" {
  backend = "remote"

  config = {
    organization = "AnikG-Org"
    workspaces = {
      name = "project-demo-prod"
    }
  }
}






