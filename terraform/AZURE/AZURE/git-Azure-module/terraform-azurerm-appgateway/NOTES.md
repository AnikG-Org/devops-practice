App Gateway V2 Steps

1) Environment must have a dedicated subnet of size /28 or greater  
* Use Create App env or Manage App env microservices  

2) Get nsg name from the subnet created in step 1    

3) Request Policy exemption for ngc-026 to allow rule on nsg from step 2 outbound   
https://wwwpwcnetwork.pwc.myshn.net/hub?id=sc_cat_item&sys_id=1fe1f0e71b0f2740f141a8217e4bcbaa&shn-direct  

Rule (Terraform module will take care of adding rule)  
```
      direction : "Outbound"  
      protocol : "*"  
      source_port_range : "*"  
      destination_port_range : "*"  
      source_address_prefix : "*"
      destination_address_prefix : "*"  
```

 Example (RITM5221186)

4) Change Outbound Security Rules in the nsg from step 2   
Open request to ngc ops  
Rule 700 Deny to Allow   
Rule 701 Deny to Alloa  w
Example (Need RITM here)

5) Update UDR to allow   
To-Internet in the route table has AddressPrefix '0.0.0.0/0'. For routes associated to subnet containing Application Gateway V2, please ensure '0.0.0.0/0' uses NextHopType as 'Internet'."   
Example (RITM5220801/CHG0488051)   

6) Three inbound rules that need to be created which the terraform module takes care of, included for documentation purposes.  
Rules:    
```
  {
      name : "APP_GW"
      priority : var.nsg.priority_inbound_prefix
      direction : "Inbound"
      protocol : "*"
      source_port_range : "*"
      destination_port_range : "65200-65535"
      source_address_prefix : "GatewayManager"
      destination_address_prefix : "*"
    },
    {
      name : "APP_GW"
      priority : var.nsg.priority_inbound_prefix
      direction : "Inbound"
      protocol : "*"
      source_port_range : "*"
      destination_port_range : "*"
      source_address_prefix : "AzureLoadBalancer"
      destination_address_prefix : "*"

    },
    {
      name : "APP_GW"
      priority : var.nsg.priority_inbound_prefix
      direction : "Inbound"
      protocol : "*"
      source_port_range : "*"
      destination_port_range : "*"
      source_address_prefix : "VirtualNetwork"
      destination_address_prefix : "*"

    },
```
       
