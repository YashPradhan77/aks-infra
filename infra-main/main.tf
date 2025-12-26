# Resource Group
data "azurerm_resource_group" "rg" {
  name = var.resource_group_name
}

# Networking Module
module "vnet" {
  source = "./modules/networking"

  # Core
  vnet_name           = var.vnet_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = data.azurerm_resource_group.rg.name
  vnet_address_space  = var.vnet_address_space

  # Subnets
  aks_subnet_name  = var.aks_subnet_name
  aks_subnet_cidrs = var.aks_subnet_cidrs
  
  # db_subnet_name  = var.db_subnet_name
  # db_subnet_cidrs = var.db_subnet_cidrs
  # db_port = var.db_port
  # redis_port = var.redis_port

  # redis_subnet_name  = var.redis_subnet_name
  # redis_subnet_cidrs = var.redis_subnet_cidrs

  # shared_subnet_name  = var.shared_subnet_name
  # shared_subnet_cidrs = var.shared_subnet_cidrs

  tags = var.tags
} 

module "aks" {
  source = "./modules/aks"

  cluster_name        = var.cluster_name
  location            = data.azurerm_resource_group.rg.location
  resource_group_name = var.resource_group_name
  kubernetes_version  = var.kubernetes_version

  vnet_subnet_id = module.vnet.aks_subnet_id
  # acr_id = module.acr.registry_id

  node_pool = {
    name       = var.node_pool.name
    vm_size    = var.node_pool.vm_size
    node_count = var.node_pool.node_count
  }
 
  # identity = var.identity

  network_profile = {
    network_plugin = var.network_profile.network_plugin
    network_policy = var.network_profile.network_policy
  }

  tags = var.tags
}

# # ACR Module
# module "acr" {
#   source = "./modules/acr"

#   registry_name       = var.registry_name
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   sku                 = var.sku
#   tags                = var.tags
# }

# # PostgreSQL Module
# module "postgresql" {
#   source = "./modules/postgresql"

#   server_name         = var.server_name
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   db_subnet_id        = module.vnet.db_subnet_id
#   vnet_id             = module.vnet.vnet_id
#   postgres_version    = var.postgres_version
#   admin_username      = var.admin_username
#   admin_password      = var.admin_password
#   postgre_sku_name    = var.postgre_sku_name
#   storage_mb          = var.storage_mb
#   tags                = var.tags
# }

# # Redis Module
# module "redis" {
#   source = "./modules/redis"

#   cache_name          = var.cache_name
#   location            = data.azurerm_resource_group.rg.location
#   resource_group_name = data.azurerm_resource_group.rg.name
#   redis_subnet_id     = module.vnet.redis_subnet_id
#   capacity            = var.capacity
#   family              = var.family
#   redis_sku_name      = var.redis_sku_name
#   private_ip          = var.private_ip
#   tags                = var.tags
# }

