variable "vnet_name" {
  type        = string
}

variable "location" {
  type        = string
}

variable "resource_group_name" {
  type        = string
}

variable "vnet_address_space" {
  type        = list(string)
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

variable "tags" {
  type    = map(string)
  default = {}
}

# variable "db_port" {
#   type    = string
#   default = "5432"
# }

# variable "redis_port" {
#   type    = string
#   default = "6379"  
# }