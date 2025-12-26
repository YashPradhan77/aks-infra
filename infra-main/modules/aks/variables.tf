
# Variable definitions for AKS module
variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "kubernetes_version" {
  description = "AKS Kubernetes version"
  type        = string
}

variable "vnet_subnet_id" {
  description = "Subnet ID where AKS nodes will be deployed"
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
    network_plugin = string        # azure or kubenet
    network_policy = string        # azure or calico
  })
}

variable "private_cluster_enabled" {
  description = "Enable private AKS cluster"
  type        = bool
  default     = false
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

# variable "acr_id" {
#   description = "The ID of the Azure Container Registry to assign AcrPull role"
#   type        = string
# }

