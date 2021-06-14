#/* #enable when required

module "vgw" {
  source = "../../modules/0.1.6.network/vpn-gateway/site"

  ################################################################################
  # common tag
  ################################################################################

  environment     = var.environment
  project         = var.project
  git_repo        = var.git_repo
  ServiceProvider = var.ServiceProvider
  ################################################################################  CGW
  #-----------------------------
  create_cgw                = false
  existing_customer_gateway = null #"cgw-0a3d5f449342bbb90" ##use existing if create_cgw = false #string /null
  #-----------------------------
  customer_gateways = { #customer_gateways not require if create_cgw = false & existing_customer_gateway = true
    HO = {
      bgp_asn    = 65000
      ip_address = "49.33.1.162"
    },
    # IP2 = {
    #   bgp_asn    = 65000
    #   ip_address = "85.38.42.93"
    # }
  }
  customer_gateway_tags = {
    Location = "HO"
  }
  ############################################################################### VGW
  #----------------------------- #enter value in below variable
  enable_vpn_gateway     = var.enable_vpn_gateway                                                            #true  
  existing_vpn_gateway   = var.existing_vpn_gateway                                                          #null #"vgw-0505b3ebcbfbf92fb"  #enter value in below variable #use existing if enable_vpn_gateway = false #string /null
  vpn_gateway_attachment = var.enable_vpn_gateway == true || var.existing_vpn_gateway != null ? true : false #true# 
  #-----------------------------
  customvgwname = "S2S"
  vpc_id        = module.aws_network_1.vpc_id

  spoke_vpc = false
  vpn_gateway_tags = {
    Location = "HO"
  }
  ################################################################################ VPN
  #-----------------------------
  create_vpn_connection = false #VPN connection
  transit_gateway_id    = null  #string/null
  #-----------------------------
  #######################
  # Use Static Routing #
  #######################  
  # disable_bgp               = true #true for static_route
  # static_routes             = ["192.168.2.0/23", "192.168.8.0/24"]
  #######################
  # Common @ Routing #
  #######################
  # preshared_keys      = ["XXXXXXXXXXXXX1", "XXXXXXXXXXXXX2"] #(OPTIONAL)Always use aws_kms_secrets to manage sensitive information: More info: https://manage.rackspace.com/aws/docs/product-guide/iac_beta/managing-secrets.html
  #######################
  # Use Dynamic Routing #
  #######################
  disable_bgp = false #false for bgp_route
  bgp_asn     = 65000
  # bgp_inside_cidrs    = ["169.254.18.0/30", "169.254.17.0/30"] #OPTIONAL
  #######################
  # Route association #
  #######################
  #-----------------------------
  enable_route_propagation = false #enable if vgw created/ existing vgw added
  #-----------------------------
  route_tables = concat(module.aws_network_1.private_aws_route_table[*], module.aws_network_1.public_aws_route_table[*])
}
#-----------------------------
variable "enable_vpn_gateway" {
  type    = bool
  default = false
}
variable "existing_vpn_gateway" { default = null }

#*/
