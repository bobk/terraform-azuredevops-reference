# for sharing between core and modules
output "rg_name" {
  description = "name of the resource group"
  value       = azurerm_resource_group.rg.name
}

output "rg_location" {
  description = "location of the resource group"
  value       = azurerm_resource_group.rg.location
}

output "sa_name" {
  description = "name of the storage account"
  value       = azurerm_storage_account.sa.name
}

output "sa_ids" {
  description = "ids of the storage account"
  value       = [azurerm_storage_account.sa.id]
}

output "kv_name" {
  description = "name of the key vault"
  value       = azurerm_key_vault.kv.name
}
