terraform init
terraform init -upgrade
terraform plan
terraform apply -force
terraform apply -var-file=prod.tfvars #
terraform refresh
terraform plan -refresh=false
terraform plan -refresh=false -target=aws_security_group.name    #Setting Refresh along with Target flags
terraform apply -auto-approve -refresh=false
terraform show
terraform state #list ...
# Subcommands:
#     list                List resources in the state
#     mv                  Move an item in the state
#     pull                Pull current state and output to stdout
#     push                Update remote state from a local state file
#     replace-provider    Replace provider in the state
#     rm                  Remove instances from the state
#     show                Show a resource in the state
terraform destroy -force
terraform console #https://www.terraform.io/docs/language/functions/index.html
terraform fmt
terraform validate
terraform get -update=true
terraform workspace # -h , show , list,delete,new,show, select [env_name]
terraform import #tf_resource.name #aws_resource_id #eg: terraform import aws_instance.myec2 i-xxxxxxxxxx    #https://www.terraform.io/docs/cli/import/index.html#currently-state-only

terraform taint aws_instance.myec2  #tainting resource 

terraform graph > graph.dot   #GraphiViz Documentation Referred in Course: https://graphviz.gitlab.io/download/
yum install graphviz
cat graph.dot | dot -Tsvg > graph.svg

export TF_LOG_PATH=/tmp/crash.log #TF_LOG_PATH="tf_log-MMDDYY_hhmmss"

export TF_LOG=TRACE     #log levels TRACE, DEBUG, INFO, WARN or ERROR
TF_IN_AUTOMATION = any #or #true #When the environment variable TF_IN_AUTOMATION is set to any non-empty value, Terraform makes some minor adjustments to its output to de-emphasize specific commands to run. The specific changes made will vary over time, but generally-speaking Terraform will consider this variable to indicate that there is some wrapping application that will help the user with the next step.



plugin_cache_dir = "$HOME/.terraform.d/plugin-cache"  #Alternatively, the TF_PLUGIN_CACHE_DIR environment variable can be used to enable caching or to override an existing cache directory within a particular shell session

on_failure #setting can be used to change this. #continue: Ignore the error and continue with creation or destruction.   #fial: Raise an error and stop applying (the default behavior). If this is a creation provisioner, taint the resource.

grep "random_password" terraform.tfstate      #get random_password from terraform.tfstate 



#terraform destroy -target=aws_s3_bucket.flow_log  #destrying specific resource #bucket forcefully
Options:

  -auto-approve          Skip interactive approval of plan before applying.

  -backup=path           Path to backup the existing state file before
                         modifying. Defaults to the "-state-out" path with
                         ".backup" extension. Set to "-" to disable backup.

  -compact-warnings      If Terraform produces any warnings that are not
                         accompanied by errors, show them in a more compact
                         form that includes only the summary messages.

  -lock=true             Lock the state file when locking is supported.

  -lock-timeout=0s       Duration to retry a state lock.

  -input=true            Ask for input for variables if not directly set.

  -no-color              If specified, output wont contain any color.

  -parallelism=n         Limit the number of parallel resource operations.
                         Defaults to 10.

  -refresh=true          Update state prior to checking for differences. This
                         has no effect if a plan file is given to apply.

  -state=path            Path to read and save state (unless state-out
                         is specified). Defaults to "terraform.tfstate".

  -state-out=path        Path to write state to that is different than
                         "-state". This can be used to preserve the old
                         state.

  -target=resource       Resource to target. Operation will be limited to this
                         resource and its dependencies. This flag can be used
                         multiple times.

  -var 'foo=bar'         Set a variable in the Terraform configuration. This
                         flag can be set multiple times.

  -var-file=foo          Set variables in the Terraform configuration from
                         a file. If "terraform.tfvars" or any ".auto.tfvars"
                         files are present, they will be automatically loaded.

#TF Cloud


# main.tf
terraform {
  required_version = "~> 0.13.0"
  backend "remote" {}
}
#######################################################
#https://www.terraform.io/docs/language/settings/backends/remote.html
#backend.hcl
workspaces { name = "project_demo" }
hostname     = "app.terraform.io"
organization = "AnikG-Org"
#######################################################
# backend tf #terraform.workspace
terraform {
  required_version = "~> 0.13"  
  backend "remote" {
    organization = "AnikG-Org"

    workspaces {
      name = "project-demo"  
      #prefix = "project_demo"
    }
  }
}
#### backend.hcl
workspaces { 
    prefix = "project-"
    #name = "project_demo" 
}
hostname     = "app.terraform.io"
organization = "AnikG-Org"

#CLI Commands used
terraform login
terraform init
terraform init -backend-config=backend.hcl #(OPTIONAL)  
terraform init -input=false -plugin-dir=/usr/lib/custom-terraform-plugins


### FYI ###
#   Enter a value: yes
# ---------------------------------------------------------------------------------
# Terraform must now open a web browser to the tokens page for app.terraform.io.
# If a browser does not open this automatically, open the following URL to proceed:
#     https://app.terraform.io/app/settings/tokens?source=terraform-login
# ---------------------------------------------------------------------------------
# Generate a token using your browser, and copy-paste it into this prompt.
# Terraform will store the token in plain text in the following file
# for use by subsequent commands:
#     C:\Users\[user]\AppData\Roaming\terraform.d\credentials.tfrc.json
# Token for app.terraform.io:
#   Enter a value: 
# Retrieved token for user anik
# ---------------------------------------------------------------------------------
# Success! Terraform has obtained and saved an API token.
# The new API token will be used for any future Terraform command that must make
# authenticated requests to app.terraform.io.
####################################################### tag policy for instances
# sentinel-policy.tf

import "tfplan"

main = rule {
  all tfplan.resources.aws_instance as _, instances {
    all instances as _, r {
      (length(r.applied.tags) else 0) > 0
    }
  }
}

