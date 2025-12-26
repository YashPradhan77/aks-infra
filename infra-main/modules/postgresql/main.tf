# resource "azurerm_private_dns_zone" "postgres" {
#   name = "${var.server_name}.private.postgres.database.azure.com"
#   resource_group_name = var.resource_group_name
#   tags = var.tags
# }

# resource "azurerm_private_dns_zone_virtual_network_link" "postgres" {
#   name = "${var.server_name}-link"
#   private_dns_zone_name = azurerm_private_dns_zone.postgres.name
#   virtual_network_id = var.vnet_id
#   resource_group_name = var.resource_group_name
# }

# resource "azurerm_postgresql_flexible_server" "postgres" {
#   name = var.server_name
#   resource_group_name = var.resource_group_name
#   location = var.location
#   version = var.postgres_version
#   delegated_subnet_id = var.db_subnet_id
#   private_dns_zone_id = azurerm_private_dns_zone.postgres.id
#   public_network_access_enabled = false
#   administrator_login = var.admin_username
#   administrator_password = var.admin_password
#   zone = "1"
#   storage_mb = var.storage_mb
#   sku_name = var.postgre_sku_name
#   backup_retention_days = 7
  
#   depends_on = [azurerm_private_dns_zone_virtual_network_link.postgres]
#   tags = var.tags
# }