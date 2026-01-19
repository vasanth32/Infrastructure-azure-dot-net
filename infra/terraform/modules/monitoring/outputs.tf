# Log Analytics Workspace Outputs
output "log_analytics_workspace_id" {
  description = "ID of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.id
}

output "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.name
}

output "log_analytics_workspace_primary_shared_key" {
  description = "Primary shared key for the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.primary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_secondary_shared_key" {
  description = "Secondary shared key for the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.secondary_shared_key
  sensitive   = true
}

output "log_analytics_workspace_workspace_id" {
  description = "Workspace ID (GUID) of the Log Analytics workspace"
  value       = azurerm_log_analytics_workspace.main.workspace_id
}

# Shared Application Insights Outputs
output "shared_application_insights_id" {
  description = "ID of the shared Application Insights instance"
  value       = var.application_insights_mode == "shared" ? azurerm_application_insights.shared[0].id : null
}

output "shared_application_insights_name" {
  description = "Name of the shared Application Insights instance"
  value       = var.application_insights_mode == "shared" ? azurerm_application_insights.shared[0].name : null
}

output "shared_instrumentation_key" {
  description = "Instrumentation key for the shared Application Insights instance"
  value       = var.application_insights_mode == "shared" ? azurerm_application_insights.shared[0].instrumentation_key : null
  sensitive   = true
}

output "shared_connection_string" {
  description = "Connection string for the shared Application Insights instance"
  value       = var.application_insights_mode == "shared" ? azurerm_application_insights.shared[0].connection_string : null
  sensitive   = true
}

output "shared_app_id" {
  description = "App ID (GUID) of the shared Application Insights instance"
  value       = var.application_insights_mode == "shared" ? azurerm_application_insights.shared[0].app_id : null
}

# ProductService Application Insights Outputs
output "product_service_application_insights_id" {
  description = "ID of the ProductService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.product_service[0].id : null
}

output "product_service_application_insights_name" {
  description = "Name of the ProductService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.product_service[0].name : null
}

output "product_service_instrumentation_key" {
  description = "Instrumentation key for the ProductService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.product_service[0].instrumentation_key : null
  sensitive   = true
}

output "product_service_connection_string" {
  description = "Connection string for the ProductService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.product_service[0].connection_string : null
  sensitive   = true
}

output "product_service_app_id" {
  description = "App ID (GUID) of the ProductService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.product_service[0].app_id : null
}

# OrderService Application Insights Outputs
output "order_service_application_insights_id" {
  description = "ID of the OrderService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.order_service[0].id : null
}

output "order_service_application_insights_name" {
  description = "Name of the OrderService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.order_service[0].name : null
}

output "order_service_instrumentation_key" {
  description = "Instrumentation key for the OrderService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.order_service[0].instrumentation_key : null
  sensitive   = true
}

output "order_service_connection_string" {
  description = "Connection string for the OrderService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.order_service[0].connection_string : null
  sensitive   = true
}

output "order_service_app_id" {
  description = "App ID (GUID) of the OrderService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.order_service[0].app_id : null
}

# NotificationService Application Insights Outputs
output "notification_service_application_insights_id" {
  description = "ID of the NotificationService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.notification_service[0].id : null
}

output "notification_service_application_insights_name" {
  description = "Name of the NotificationService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.notification_service[0].name : null
}

output "notification_service_instrumentation_key" {
  description = "Instrumentation key for the NotificationService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.notification_service[0].instrumentation_key : null
  sensitive   = true
}

output "notification_service_connection_string" {
  description = "Connection string for the NotificationService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.notification_service[0].connection_string : null
  sensitive   = true
}

output "notification_service_app_id" {
  description = "App ID (GUID) of the NotificationService Application Insights instance"
  value       = var.application_insights_mode == "per-service" ? azurerm_application_insights.notification_service[0].app_id : null
}

# Generic Outputs (for convenience)
output "workspace_id" {
  description = "Workspace ID of the Log Analytics workspace (alias for log_analytics_workspace_id)"
  value       = azurerm_log_analytics_workspace.main.id
}

output "instrumentation_key" {
  description = "Instrumentation key (shared or ProductService, depending on mode)"
  value = var.application_insights_mode == "shared" ? (
    azurerm_application_insights.shared[0].instrumentation_key
  ) : (
    var.application_insights_mode == "per-service" ? azurerm_application_insights.product_service[0].instrumentation_key : null
  )
  sensitive = true
}

# All Instrumentation Keys (for per-service mode)
output "all_instrumentation_keys" {
  description = "Map of all instrumentation keys (for per-service mode)"
  value = var.application_insights_mode == "per-service" ? {
    product_service     = azurerm_application_insights.product_service[0].instrumentation_key
    order_service      = azurerm_application_insights.order_service[0].instrumentation_key
    notification_service = azurerm_application_insights.notification_service[0].instrumentation_key
  } : null
  sensitive = true
}
