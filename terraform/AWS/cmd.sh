terraform init
terraform init -upgrade
terraform plan
terraform apply -force
terraform refresh
terraform plan -refresh=false
terraform plan -refresh=false -target=aws_security_group.name    #Setting Refresh along with Target flags
terraform apply -auto-approve -refresh=false
terraform show
terraform state list
terraform destroy -force
terraform console #https://www.terraform.io/docs/language/functions/index.html
terraform fmt
terraform validate
terraform workspace # -h , show , list,delete,new,show, select [env_name]

terraform taint aws_instance.myec2  #tainting resource 

terraform graph > graph.dot   #GraphiViz Documentation Referred in Course: https://graphviz.gitlab.io/download/
yum install graphviz
cat graph.dot | dot -Tsvg > graph.svg

export TF_LOG_PATH=/tmp/crash.log
export TF_LOG=TRACE     #log levels TRACE, DEBUG, INFO, WARN or ERROR

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

  -no-color              If specified, output won't contain any color.

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