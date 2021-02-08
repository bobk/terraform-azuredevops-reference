resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.suffix}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_storage_account" "sa" {
  name                         = "sa${var.suffix}"
  resource_group_name          = azurerm_resource_group.rg.name
  location                     = var.location
  tags                         = var.tags
  account_tier                 = var.sa_account_tier
  account_replication_type     = var.sa_account_replication_type
  min_tls_version              = "TLS1_2"
  enable_https_traffic_only    = true
  network_rules {
      default_action           = "Deny"
  }
}

data "azurerm_client_config" "current" {}

resource "azurerm_key_vault" "kv" {
  name                        = "kv${var.suffix}"
  resource_group_name         = azurerm_resource_group.rg.name
  location                    = azurerm_resource_group.rg.location
  tags                        = var.tags
  enabled_for_disk_encryption = true
  tenant_id                   = data.azurerm_client_config.current.tenant_id
  soft_delete_retention_days  = 7
#  soft_delete_enabled         = true
  purge_protection_enabled    = true
  sku_name                    = var.kv_sku_name

  access_policy {
    tenant_id = data.azurerm_client_config.current.tenant_id
    object_id = data.azurerm_client_config.current.object_id

    key_permissions = [
      "get",
    ]

    secret_permissions = [
      "get",
    ]

    storage_permissions = [
      "get",
    ]
  }
}
