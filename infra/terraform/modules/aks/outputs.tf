# Cluster Information
output "cluster_id" {
  description = "ID of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.id
}

output "cluster_name" {
  description = "Name of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.name
}

output "cluster_fqdn" {
  description = "FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.fqdn
}

output "cluster_private_fqdn" {
  description = "Private FQDN of the AKS cluster"
  value       = azurerm_kubernetes_cluster.main.private_fqdn
}

# Kubernetes Configuration
output "kube_config" {
  description = "Raw Kubernetes config to be used by kubectl and other compatible tools"
  value       = azurerm_kubernetes_cluster.main.kube_config_raw
  sensitive   = true
}

output "host" {
  description = "Kubernetes cluster server host"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].host
  sensitive   = true
}

output "client_key" {
  description = "Base64 encoded private key used by clients to authenticate to the cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_key
  sensitive   = true
}

output "client_certificate" {
  description = "Base64 encoded public certificate used by clients to authenticate to the cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].client_certificate
  sensitive   = true
}

output "cluster_ca_certificate" {
  description = "Base64 encoded public CA certificate used as the root of trust for the cluster"
  value       = azurerm_kubernetes_cluster.main.kube_config[0].cluster_ca_certificate
  sensitive   = true
}

# Node Pool Information
output "system_node_pool_id" {
  description = "ID of the system node pool (default node pool)"
  value       = "${azurerm_kubernetes_cluster.main.id}/agentPools/systempool"
}

output "user_node_pool_id" {
  description = "ID of the user node pool"
  value       = azurerm_kubernetes_cluster.main.id != null ? azurerm_kubernetes_cluster_node_pool.userpool.id : null
}

output "user_node_pool_name" {
  description = "Name of the user node pool"
  value       = azurerm_kubernetes_cluster_node_pool.userpool.name
}

# Identity Information
output "cluster_identity" {
  description = "Managed identity used by the cluster"
  value = {
    principal_id = azurerm_kubernetes_cluster.main.identity[0].principal_id
    tenant_id    = azurerm_kubernetes_cluster.main.identity[0].tenant_id
  }
}

# Network Information
output "network_plugin" {
  description = "Network plugin used by the cluster"
  value       = azurerm_kubernetes_cluster.main.network_profile[0].network_plugin
}

output "network_policy" {
  description = "Network policy used by the cluster"
  value       = azurerm_kubernetes_cluster.main.network_profile[0].network_policy
}

# Azure Monitor
output "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID (if Azure Monitor is enabled)"
  value       = var.enable_azure_monitor ? var.log_analytics_workspace_id : null
}

# RBAC Information
output "rbac_enabled" {
  description = "Whether RBAC is enabled"
  value       = azurerm_kubernetes_cluster.main.role_based_access_control_enabled
}

output "azure_rbac_enabled" {
  description = "Whether Azure RBAC is enabled"
  value       = var.enable_azure_rbac
}

# Kubernetes Version
output "kubernetes_version" {
  description = "Kubernetes version of the cluster"
  value       = azurerm_kubernetes_cluster.main.kubernetes_version
}

# Portal URL
output "portal_fqdn" {
  description = "FQDN for the Azure Portal to access the cluster"
  value       = "https://portal.azure.com/#@/resource${azurerm_kubernetes_cluster.main.id}"
}
