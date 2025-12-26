# Common
variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "subscription_id" {
  description = "Azure Subscription ID"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# Variable definitions for AKS module
variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  type        = string
}

variable "node_pool" {
  description = "Default node pool configuration"
  type = object({
    name       = string
    vm_size    = string
    node_count = number
  })
}

# variable "identity" {
#   description = "Managed identity configuration for AKS"
#   type = string
# }

variable "network_profile" {
  description = "AKS networking configuration"
  type = object({
    network_plugin = string 
    network_policy = string 
  })
}

variable "private_cluster_enabled" {
  description = "Enable private AKS cluster"
  type        = bool
  default     = false
}

# Variable definitions for VNET module
variable "vnet_name" {
  type = string
}

variable "vnet_address_space" {
  type = list(string)
}

variable "aks_subnet_name" {
  type = string
}

variable "aks_subnet_cidrs" {
  type = list(string)
}

# variable "db_subnet_name" {
#   type = string
# }

# variable "db_subnet_cidrs" {
#   type = list(string)
# }

# variable "redis_subnet_name" {
#   type = string
# }

# variable "redis_subnet_cidrs" {
#   type = list(string)
# }

# variable "shared_subnet_name" {
#   type = string
# }

# variable "shared_subnet_cidrs" {
#   type = list(string)
# }

# variable "db_port" {
#   type    = string
#   default = "5432"
# }

# variable "redis_port" {
#   type    = string
#   default = "6379"  
# }

# # Variable definitions for ACR module
# variable "registry_name" {
#   type = string
# }

# variable "sku" {
#   type = string
# }

# # Variable definitions for PostgreSQL module
# variable "server_name" {
#   type = string
# }

# variable "vnet_id" {
#   type = string
# }

# variable "postgres_version" {
#   type = string
# }

# variable "admin_username" {
#   type = string
# }

# variable "admin_password" {
#   type      = string
#   sensitive = true
# }

# variable "storage_mb" {
#   type = number
# }

# variable "postgre_sku_name" {
#   type = string
# }

# # Variable definitions for Redis module
# variable "cache_name" {
#   type = string
# }

# variable "capacity" {
#   type = number
# }

# variable "family" {
#   type = string
# }

# variable "redis_sku_name" {
#   type = string
# }

# variable "private_ip" {
#   type = string
# }
