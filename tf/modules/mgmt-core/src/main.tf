resource "azurerm_resource_group" "rg" {
  name     = "rg-${var.suffix}"
  location = var.location
  tags     = var.tags
}

resource "azurerm_log_analytics_workspace" "laws" {
  name                = "laws${var.suffix}"
  resource_group_name = azurerm_resource_group.rg.name
  location            = var.location
  tags                = var.tags
  sku                 = var.la_sku
  retention_in_days   = var.la_retention_in_days
}

resource "azurerm_log_analytics_linked_storage_account" "lalsa" {
  data_source_type      = "customlogs"
  resource_group_name   = azurerm_resource_group.rg.name
  workspace_resource_id = azurerm_log_analytics_workspace.laws.id
  storage_account_ids   = var.lalsa_ids
}
