locals {

  thales_tenant_id = "513294a0-3e20-41b2-a970-6d30bf1546fa"

  thales_object_id = var.production ? "bb90993a-b212-44b7-b0dc-91c712705913" : "40251e04-f1ff-4aa2-b0a7-adb2d89d3a04"

  keys = concat(var.keys, [
    "storageaccounts-cm-key",
    "postgresql-cm-key",
    "sql-server-cm-key",
    "disk-encryption-cm-key"
  ])

  tags = {
    ghs-udt1 = "thales"
  }

  tfe_subnets = [
    "/subscriptions/09fc7e82-83be-4dac-ba29-7854fe2b7704/resourceGroups/PZI-GXUS-GS-RGP-BASE-P007/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P007/subnets/PZI-GXUS-G-SNT-HTFE-P001",  // single-node dev
    "/subscriptions/b5fda631-44bf-4470-bf2c-259d09649075/resourceGroups/PZI-GXUS-GS-RGP-BASE-P002/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P002/subnets/PZI-GXUS-GS-SNT-HTFE-P003", // single-node stage
    "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-HTFE-P002", // single-node prod
    "/subscriptions/09fc7e82-83be-4dac-ba29-7854fe2b7704/resourceGroups/PZI-GXUS-GS-RGP-BASE-P007/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P007/subnets/PZI-GXUS-GS-SNT-PTFE-D002", // dev
    "/subscriptions/b5fda631-44bf-4470-bf2c-259d09649075/resourceGroups/PZI-GXUS-GS-RGP-BASE-P002/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P002/subnets/PZI-GXUS-GS-SNT-PTFE-S002", // stage
    "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-PTFE-P003", // west
    "/subscriptions/2451960b-4034-4fe2-8403-4927b3ff1e40/resourceGroups/PZI-GXEU-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXEU-GS-VNT-P001/subnets/PZI-GXEU-GS-SNT-PTFE-P002", // central
    "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-PTFE-P002", // east
    "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-PTFE-P004"  // global
  ]

  # get the variables for this environment
  env = lookup(lookup(local.env_vars, var.location), var.production ? "prod" : "stage")

  # environment-specific variables
  env_vars = {

    eastus = {
      stage = {
        keymgmt = {
          sequence_no = "001"
          app_env_code = "S"
        }
        tags = {
          ghs-environmental_details = "stg-us"
          ghs-udt4 = "US"
        }
        ip_rules = []
        virtual_network_subnet_ids = [
          "/subscriptions/b5fda631-44bf-4470-bf2c-259d09649075/resourceGroups/pzi-gxus-gs-rgp-base-p002/providers/microsoft.network/virtualnetworks/pzi-gxus-gs-vnt-p002/subnets/pzi-gxus-gs-snt-thal-s001",
          "/subscriptions/b5fda631-44bf-4470-bf2c-259d09649075/resourceGroups/pzi-gxus-gs-rgp-base-p002/providers/microsoft.network/virtualnetworks/pzi-gxus-gs-vnt-p002/subnets/pzi-gxus-gs-snt-thal-s002",
          "/subscriptions/b5fda631-44bf-4470-bf2c-259d09649075/resourceGroups/pzi-gxus-gs-rgp-base-p002/providers/microsoft.network/virtualnetworks/pzi-gxus-gs-vnt-p002/subnets/pzi-gxus-gs-snt-thal-s003",
        ]
      }

      prod = {
        keymgmt = {
          sequence_no = "001"
          app_env_code = "P"
        }
        tags = {
          ghs-environmental_details = "prd-us"
          ghs-udt4 = "US"
        }
        ip_rules = []
        virtual_network_subnet_ids = [
          "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-THAL-P001",
          "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-THAL-P002",
          "/subscriptions/f5c5cb73-1f18-4137-a683-2101e212bbf9/resourceGroups/PZI-GXUS-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXUS-GS-VNT-P001/subnets/PZI-GXUS-GS-SNT-THAL-P003"
        ]
      }
    }

    westeurope = {
      stage = {
        keymgmt = {
            sequence_no = "001"
            app_env_code = "S"
        }
        tags = {
          ghs-environmental_details = "stg-emea"
          ghs-udt4 = "WE"
        }
        ip_rules = []
        virtual_network_subnet_ids = [
          "/subscriptions/2451960b-4034-4fe2-8403-4927b3ff1e40/resourceGroups/PZI-GXEU-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXEU-GS-VNT-P001/subnets/PZI-GXEU-GS-SNT-THAL-S001",
          "/subscriptions/2451960b-4034-4fe2-8403-4927b3ff1e40/resourceGroups/PZI-GXEU-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXEU-GS-VNT-P001/subnets/PZI-GXEU-GS-SNT-THAL-S002",
          "/subscriptions/2451960b-4034-4fe2-8403-4927b3ff1e40/resourceGroups/PZI-GXEU-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXEU-GS-VNT-P001/subnets/PZI-GXEU-GS-SNT-THAL-S003"
        ]
      }

      prod = {
        keymgmt = {
            sequence_no = "001"
            app_env_code = "P"
        }
        tags = {
          ghs-environmental_details = "prd-emea"
          ghs-udt4 = "WE"
        }
        ip_rules = []
        virtual_network_subnet_ids = [
          "/subscriptions/2451960b-4034-4fe2-8403-4927b3ff1e40/resourceGroups/PZI-GXEU-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXEU-GS-VNT-P001/subnets/PZI-GXEU-GS-SNT-THAL-P001",
          "/subscriptions/2451960b-4034-4fe2-8403-4927b3ff1e40/resourceGroups/PZI-GXEU-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXEU-GS-VNT-P001/subnets/PZI-GXEU-GS-SNT-THAL-P002",
          "/subscriptions/2451960b-4034-4fe2-8403-4927b3ff1e40/resourceGroups/PZI-GXEU-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXEU-GS-VNT-P001/subnets/PZI-GXEU-GS-SNT-THAL-P003"
        ]
      }
    }

    eastasia = {
      stage = {
        keymgmt = {
            sequence_no = "001"
            app_env_code = "S"
        }
        tags = {
          ghs-environmental_details = "stg-apac"
          ghs-udt4 = "SE"
        }
        ip_rules = [ "155.201.42.101/32" , "52.173.198.38/32", "20.185.208.6/32", "13.107.6.0/24", "13.107.9.0/24", "13.107.42.0/24", "13.107.43.0/24", "155.201.150.0/24", "155.201.35.69/32" ]
        virtual_network_subnet_ids = [
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-S001",
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-S002",
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-S003"
        ]
      }

      prod = {
        keymgmt = {
            sequence_no = "001"
            app_env_code = "P"
        }
        tags = {
          ghs-environmental_details = "prd-apac"
          ghs-udt4 = "SE"
        }
        ip_rules = []
        virtual_network_subnet_ids = [
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-P001",
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-P002",
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-P003"
        ]
      }
    }

    australiaeast = {
      stage = {
        keymgmt = {
            sequence_no = "001"
            app_env_code = "P"
        }
        tags = {
          ghs-environmental_details = "prd-au"
          ghs-udt4 = "AU"
        }
        ip_rules = []
        virtual_network_subnet_ids = [
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-P001",
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-P002",
          "/subscriptions/5e0e61cb-a384-47b6-9c36-2ca67935815e/resourceGroups/PZI-GXSE-GS-RGP-BASE-P001/providers/Microsoft.Network/virtualNetworks/PZI-GXSE-GS-VNT-P001/subnets/PZI-GXSE-GS-SNT-THAL-P003"
        ]
      }
    }

  }
}
