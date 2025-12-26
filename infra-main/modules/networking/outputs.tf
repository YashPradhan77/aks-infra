output "vnet_id" {
  description = "VNet ID"
  value       = module.vnet.resource.id
}

output "aks_subnet_id" {
  value = module.vnet.subnets["aks"].resource_id
}

# output "db_subnet_id" {
#   description = "Database subnet ID"
#   value       = azurerm_subnet.db.id
# }

# output "redis_subnet_id" {
#   description = "Redis subnet ID"
#   value       = module.vnet.subnets["redis"].resource_id
# }

# output "shared_subnet_id" {
#   description = "Shared subnet ID"
#   value       = module.vnet.subnets["shared"].resource_id
# }

output "aks_nsg_id" {
  description = "AKS Subnet Network Security Group ID"
  value       = azurerm_network_security_group.aks.id
}