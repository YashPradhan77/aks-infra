# resource "azurerm_redis_cache" "redis" {
#   name = var.cache_name
#   location = var.location
#   resource_group_name = var.resource_group_name
#   capacity = var.capacity
#   family = var.family
#   sku_name = var.redis_sku_name
#   minimum_tls_version = "1.2"
#   subnet_id = var.redis_subnet_id
#   private_static_ip_address = var.private_ip
  
#   tags = var.tags
# }