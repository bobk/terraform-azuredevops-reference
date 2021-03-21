output "rg_name" {
  description = "name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "rg_location" {
  description = "location of the resource group"
  value       = azurerm_resource_group.rg.location
}

output "laws_name" {
  description = "name of the log analytics workspace"
  value       = azurerm_log_analytics_workspace.laws.name
}
