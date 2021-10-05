variable "app_service_id" {
    type = string
    description = "The ID of the App Service to associate to the VNet."
}

variable "subnet_id" {
    type = string
    description = "The ID of the subnet the app service will be associated to (the subnet must have a service_delegation configured for Microsoft.Web/serverFarms)."
}
