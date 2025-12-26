module "aks-cluster" {
  source  = "Azure/aks/azurerm"
  version = "11.0.0"
  prefix = "aks-dev"

  cluster_name        = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  kubernetes_version  = var.kubernetes_version
  # private_cluster_enabled = true

  # Azure Monitor
  oms_agent_enabled = false
  log_analytics_workspace_enabled = false

  # If using UserAssigned identity, uncomment below
  # identity_type = var.identity
  # identity_ids  = [azurerm_user_assigned_identity.aks_kubelet.id]

  # kubelet_identity can be specified if more control is needed over the identity used by kubelets ( UserAssigned )
  # kubelet_identity = {
  #   client_id                 = azurerm_user_assigned_identity.aks_kubelet.client_id
  #   object_id                 = azurerm_user_assigned_identity.aks_kubelet.principal_id
  #   user_assigned_identity_id = azurerm_user_assigned_identity.aks_kubelet.id
  # }

  # To give AKS access to ACR
  # attached_acr_id_map = {
  #   myacr = var.acr_id
  # }

  node_pools = {
    system = {
      name       = "system"
      vm_size    = var.node_pool.vm_size
      node_count = var.node_pool.node_count
      mode       = "System"
      subnet_id  = var.vnet_subnet_id
    }
  }

  network_plugin = "azure"

  oidc_issuer_enabled = true
  workload_identity_enabled = true

  tags                = var.tags
}

