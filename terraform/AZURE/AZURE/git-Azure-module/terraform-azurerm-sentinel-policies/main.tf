//Provider

//Policy Set
resource "tfe_policy_set" "global" {
  name         = "global"
  description  = "Policies that should be enforced on ALL infrastructure."
  organization = "${var.tfe_organization}"
  global       = true
  policy_ids = [
    "${tfe_sentinel_policy.passthrough.id}",
    "${tfe_sentinel_policy.sp001-tf-enforce-required-tags.id}",
    "${tfe_sentinel_policy.sp003-tf-restrict-private-modules.id}",
    "${tfe_sentinel_policy.sp005-tf-restrict-resources-to-modules.id}",
    "${tfe_sentinel_policy.sp101-azure-restrict-general-roles.id}",
    "${tfe_sentinel_policy.sp102-azure-enforce-storage-account-https.id}",
    "${tfe_sentinel_policy.sp103-azure-enforce-blob-encryption.id}",
    "${tfe_sentinel_policy.sp105-azure-enforce-storage-account-sas-https-only.id}",
    "${tfe_sentinel_policy.sp106-azure-enforce-storage-account-file-encryption.id}",
    "${tfe_sentinel_policy.sp107-azure-enforce-private-storage-account-access-only.id}",
    "${tfe_sentinel_policy.sp126-azure-enforce-sql-db-threat-detection.id}",
    "${tfe_sentinel_policy.sp127-azure-enforce-sql-db-threat-detection-alerts-enabled.id}",
    "${tfe_sentinel_policy.sp128-azure-enforce-sql-db-threat-detection-alert-recipients.id}",
    "${tfe_sentinel_policy.sp129-azure-enforce-sql-db-threat-detection-email_admins_enabled.id}",
    "${tfe_sentinel_policy.sp133-azure-restrict-vm-images.id}",
    "${tfe_sentinel_policy.sp134-azure-enforce-app-service-min-tls.id}",
    "${tfe_sentinel_policy.sp135-azure-enforce-app-service-https-only.id}",
    "${tfe_sentinel_policy.sp136-azure-restrict-sql-firewall-rules.id}",
    "${tfe_sentinel_policy.sp137-azure-enforce-managed-disk-encryption.id}",
    "${tfe_sentinel_policy.sp138-azure-enforce-data-lake-store-encryption.id}",
    "${tfe_sentinel_policy.sp139-azure-enforce-key-vault-nacl-deault-deny.id}",
    "${tfe_sentinel_policy.sp140-azure-deny-nic-public-ips.id}",
    "${tfe_sentinel_policy.sp141-azure-enforce-subnet-vnet-endpoints.id}",
    "${tfe_sentinel_policy.sp142-azure-enforce-redis-ssl-ports.id}",
    "${tfe_sentinel_policy.sp143-azure-deny-servicebus-namespace-auth-rules.id}",
    "${tfe_sentinel_policy.sp144-azure-enforce-cosmosdb-vnet-rule.id}"
  ]
}

//Policies

resource "tfe_sentinel_policy" "passthrough" {
  name         = "passthrough"
  description  = "Just passing through! Always returns 'true'. "
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/passthrough.sentinel")}"
  enforce_mode = "${var.policy_level_1}"
}

resource "tfe_sentinel_policy" "sp001-tf-enforce-required-tags" {
  name         = "sp001-tf-enforce-required-tags"
  description  = "Checks taggable resources for required set of tags."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp001-tf-enforce-required-tags.sentinel")}"
  enforce_mode = "${var.policy_level_3}"
}

resource "tfe_sentinel_policy" "sp003-tf-restrict-private-modules" {
  name         = "sp003-tf-restrict-private-modules"
  description  = "Checks that modules being utilized are from an approved source."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp003-tf-restrict-private-modules.sentinel")}"
  enforce_mode = "${var.policy_level_3}"
}

resource "tfe_sentinel_policy" "sp005-tf-restrict-resources-to-modules" {
  name         = "sp005-tf-restrict-resources-to-modules"
  description  = "Checks that resources are being consumed only through the use of modules."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp005-tf-restrict-resources-to-modules.sentinel")}"
  enforce_mode = "${var.policy_level_3}"
}

resource "tfe_sentinel_policy" "sp101-azure-restrict-general-roles" {
  name         = "sp101-azure-restrict-general-roles"
  description  = "Checks for prohibited generic Azure RBAC Role assignments. Owner, Contributor, User Admin, Network Contributor"
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp101-azure-restrict-general-roles.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp102-azure-enforce-storage-account-https" {
  name         = "sp102-azure-enforce-storage-account-https"
  description  = "Checks for the https_only attribute to be set for Azure Storage Accounts."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp102-azure-enforce-storage-account-https.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp103-azure-enforce-blob-encryption" {
  name         = "sp103-azure-enforce-blob-encryption"
  description  = "Checks for the blob encryption to be enabled on Azure Storage Accounts."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp103-azure-enforce-blob-encryption.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp105-azure-enforce-storage-account-sas-https-only" {
  name         = "sp105-azure-enforce-storage-account-sas-https-only"
  description  = "Checks for Storage Account SAS tokens to use https only."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp105-azure-enforce-storage-account-sas-https-only.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp106-azure-enforce-storage-account-file-encryption" {
  name         = "sp106-azure-enforce-storage-account-file-encryption"
  description  = "Checks for Azure Storage Accounts to have file encryption enabled."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp106-azure-enforce-storage-account-file-encryption.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp107-azure-enforce-private-storage-account-access-only" {
  name         = "sp107-azure-enforce-private-storage-account-access-only"
  description  = "Checks for Azure Storage Containers to have access set to 'Private'."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp107-azure-enforce-private-storage-account-access-only.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp126-azure-enforce-sql-db-threat-detection" {
  name         = "sp126-azure-enforce-sql-db-threat-detection"
  description  = "Checks for SQL Databases to have threat detection enabled."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp126-azure-enforce-sql-db-threat-detection.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp127-azure-enforce-sql-db-threat-detection-alerts-enabled" {
  name         = "sp127-azure-enforce-sql-db-threat-detection-alerts-enabled"
  description  = "Checks for SQL Databases to have all threat detection alerts enabled."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp127-azure-enforce-sql-db-threat-detection-alerts-enabled.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp128-azure-enforce-sql-db-threat-detection-alert-recipients" {
  name         = "sp128-azure-enforce-sql-db-threat-detection-alert-recipients"
  description  = "Checks for SQL Databases to have threat detection alert email recipients."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp128-azure-enforce-sql-db-threat-detection-alert-recipients.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp129-azure-enforce-sql-db-threat-detection-email_admins_enabled" {
  name         = "sp129-azure-enforce-sql-db-threat-detection-email_admins_enabled"
  description  = "Checks for SQL Databases to have threat detection email adminstrators enabled."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp129-azure-enforce-sql-db-threat-detection-email_admins_enabled.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp134-azure-enforce-app-service-min-tls" {
  name         = "sp134-azure-enforce-app-service-min-tls"
  description  = "Checks App Services to have minimum TLS version of 1.2."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp134-azure-enforce-app-service-min-tls.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp135-azure-enforce-app-service-https-only" {
  name         = "sp135-azure-enforce-app-service-https-onlys"
  description  = "Checks App Services are set to https_only."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp135-azure-enforce-app-service-https-only.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp136-azure-restrict-sql-firewall-rules" {
  name         = "sp136-azure-restrict-sql-firewall-rules"
  description  = "Checks Sql server firewall rules to not be open to 0.0.0.0/0."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp136-azure-restrict-sql-firewall-rules.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp137-azure-enforce-managed-disk-encryption" {
  name         = "sp137-azure-enforce-managed-disk-encryption"
  description  = "Checks managed disks to ensure they are encrypted."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp137-azure-enforce-managed-disk-encryption.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp138-azure-enforce-data-lake-store-encryption" {
  name         = "sp138-azure-enforce-data-lake-store-encryption"
  description  = "Checks that Data Lake Stores are encrypted."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp138-azure-enforce-data-lake-store-encryption.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp139-azure-enforce-key-vault-nacl-deault-deny" {
  name         = "sp139-azure-enforce-key-vault-nacl-deault-deny"
  description  = "Checks KeyVault firewalls to ensure the default action is not 'Deny'."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp139-azure-enforce-key-vault-nacl-deault-deny.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp140-azure-deny-nic-public-ips" {
  name         = "sp140-azure-deny-nic-public-ips"
  description  = "Checks network interfaces to ensure that no public IP addresses are attached."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp140-azure-deny-nic-public-ips.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp141-azure-enforce-subnet-vnet-endpoints" {
  name         = "sp141-azure-enforce-subnet-vnet-endpoints"
  description  = "Checks subnets to ensure that they have all VNET service endpoints enabled."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp141-azure-enforce-subnet-vnet-endpoints.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp142-azure-enforce-redis-ssl-ports" {
  name         = "sp142-azure-enforce-redis-ssl-ports"
  description  = "Checks Redis caches to ensure that non-SSL ports are not enabled."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp142-azure-enforce-redis-ssl-ports.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp143-azure-deny-servicebus-namespace-auth-rules" {
  name         = "sp143-azure-deny-servicebus-namespace-auth-rules"
  description  = "Checks that ServiceBus authorization rules are not defined at the Namespace level."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp143-azure-deny-servicebus-namespace-auth-rules.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp144-azure-enforce-cosmosdb-vnet-rule" {
  name         = "sp144-azure-enforce-cosmosdb-vnet-rule"
  description  = "Checks CosmosDB accounts to ensure that they have virtual network rules defined."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp144-azure-enforce-cosmosdb-vnet-rule.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}

resource "tfe_sentinel_policy" "sp133-azure-restrict-vm-images" {
  name         = "sp133-azure-restrict-vm-images"
  description  = "Checks Azure virutal machines to ensure they are launched from images sourced from the Shared Image Gallery."
  organization = "${var.tfe_organization}"
  policy       = "${file("./policies/sp133-azure-restrict-vm-images.sentinel")}"
  enforce_mode = "${var.policy_level_2}"
}