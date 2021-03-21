# for sharing between core and modules
output "lz-core_rg_name" {
  description = "name of the lz-core resource group"
  value       = module.lz-core.rg_name
}

output "lz-core_sa_name" {
  description = "name of the lz-core storage account"
  value       = module.lz-core.sa_name
}

output "lz-core_kv_name" {
  description = "name of the lz-core key vault"
  value       = module.lz-core.kv_name
}

output "mgmt-core_rg_name" {
  description = "name of the mgmt-core resource group"
  value       = module.mgmt-core.rg_name
}

output "mgmt-core_laws_name" {
  description = "name of the mgmt-core log analytics workspace"
  value       = module.mgmt-core.laws_name
}
