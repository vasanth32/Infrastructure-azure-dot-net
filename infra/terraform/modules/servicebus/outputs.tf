# Namespace Information
output "namespace_id" {
  description = "ID of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.id
}

output "namespace_name" {
  description = "Name of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.name
}

output "namespace_fqdn" {
  description = "FQDN of the Service Bus namespace (format: {namespace}.servicebus.windows.net)"
  value       = "${azurerm_servicebus_namespace.main.name}.servicebus.windows.net"
}

# Connection Strings
# Use default connection string from namespace (RootManageSharedAccessKey is auto-created)
output "connection_string" {
  description = "Primary connection string for the Service Bus namespace (uses default RootManageSharedAccessKey)"
  value       = azurerm_servicebus_namespace.main.default_primary_connection_string
  sensitive   = true
}

output "primary_connection_string" {
  description = "Primary connection string for the Service Bus namespace (uses default RootManageSharedAccessKey)"
  value       = azurerm_servicebus_namespace.main.default_primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "Secondary connection string for the Service Bus namespace (uses default RootManageSharedAccessKey)"
  value       = azurerm_servicebus_namespace.main.default_secondary_connection_string
  sensitive   = true
}

output "primary_key" {
  description = "Primary shared access key (from default RootManageSharedAccessKey)"
  value       = azurerm_servicebus_namespace.main.default_primary_key
  sensitive   = true
}

output "secondary_key" {
  description = "Secondary shared access key (from default RootManageSharedAccessKey)"
  value       = azurerm_servicebus_namespace.main.default_secondary_key
  sensitive   = true
}

# Queue Information
output "queue_name" {
  description = "Name of the notification queue"
  value       = azurerm_servicebus_queue.notification_queue.name
}

output "queue_id" {
  description = "ID of the notification queue"
  value       = azurerm_servicebus_queue.notification_queue.id
}

# Queue Connection Strings (if queue authorization rule is created)
output "queue_connection_string" {
  description = "Primary connection string for the queue (if queue authorization rule is created)"
  value       = var.create_queue_authorization_rule ? azurerm_servicebus_queue_authorization_rule.notification_queue_rule[0].primary_connection_string : null
  sensitive   = true
}

output "queue_primary_key" {
  description = "Primary shared access key for the queue (if queue authorization rule is created)"
  value       = var.create_queue_authorization_rule ? azurerm_servicebus_queue_authorization_rule.notification_queue_rule[0].primary_key : null
  sensitive   = true
}

# Identity Information
output "namespace_identity" {
  description = "Managed identity of the Service Bus namespace"
  value = azurerm_servicebus_namespace.main.identity[0].principal_id != null ? {
    principal_id = azurerm_servicebus_namespace.main.identity[0].principal_id
    tenant_id    = azurerm_servicebus_namespace.main.identity[0].tenant_id
  } : null
}

# SKU Information
output "sku" {
  description = "SKU of the Service Bus namespace"
  value       = azurerm_servicebus_namespace.main.sku
}

output "capacity" {
  description = "Capacity of the Service Bus namespace (Premium SKU)"
  value       = azurerm_servicebus_namespace.main.capacity
}
