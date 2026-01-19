output "resource_group_name" {
  description = "Name of the resource group"
  value       = azurerm_resource_group.microservices.name
}

output "resource_group_location" {
  description = "Location of the resource group"
  value       = azurerm_resource_group.microservices.location
}

output "resource_group_id" {
  description = "ID of the resource group"
  value       = azurerm_resource_group.microservices.id
}

output "aks_cluster_name" {
  description = "Name of the AKS cluster"
  value       = var.aks_cluster_name
}

output "acr_name" {
  description = "Name of the Azure Container Registry"
  value       = var.acr_name
}

output "acr_login_server" {
  description = "Login server URL for ACR (will be populated after ACR is created)"
  value       = "${var.acr_name}.azurecr.io"
  # Note: This will be updated when ACR resource is added
}

# Monitoring Outputs
output "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  value       = module.monitoring.log_analytics_workspace_id
}

output "application_insights_instrumentation_key" {
  description = "Application Insights Instrumentation Key"
  value       = module.monitoring.instrumentation_key
  sensitive   = true
}

# Service Bus Outputs
output "service_bus_connection_string" {
  description = "Service Bus connection string"
  value       = module.servicebus.connection_string
  sensitive   = true
}

output "service_bus_queue_name" {
  description = "Service Bus queue name"
  value       = module.servicebus.queue_name
}

# Database Outputs
output "product_service_db_connection_string" {
  description = "ProductService database connection string"
  value       = module.databases.product_service_connection_string
  sensitive   = true
}

output "order_service_db_connection_string" {
  description = "OrderService database connection string"
  value       = module.databases.order_service_connection_string
  sensitive   = true
}

# AKS Outputs
output "aks_cluster_id" {
  description = "AKS cluster ID"
  value       = module.aks.cluster_id
}

output "aks_cluster_fqdn" {
  description = "AKS cluster FQDN"
  value       = module.aks.cluster_fqdn
}

output "aks_cluster_private_fqdn" {
  description = "AKS cluster private FQDN"
  value       = module.aks.cluster_private_fqdn
}
