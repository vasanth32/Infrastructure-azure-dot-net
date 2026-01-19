# Azure Service Bus Namespace
resource "azurerm_servicebus_namespace" "main" {
  name                = var.namespace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.sku
  capacity            = var.capacity

  # Premium tier features
  zone_redundant = var.sku == "Premium" ? var.zone_redundant : false

  # Identity
  identity {
    type = var.identity_type
  }

  # Local authentication
  local_auth_enabled = var.local_auth_enabled

  # Minimum TLS version
  minimum_tls_version = var.minimum_tls_version

  # Public network access
  public_network_access_enabled = var.public_network_access_enabled

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

# Service Bus Queue for Notifications
resource "azurerm_servicebus_queue" "notification_queue" {
  name         = var.queue_name
  namespace_id = azurerm_servicebus_namespace.main.id

  # Queue settings
  max_delivery_count                  = var.max_delivery_count
  max_size_in_megabytes               = var.max_size_in_megabytes
  default_message_ttl                 = var.default_message_ttl
  lock_duration                       = var.lock_duration
  dead_lettering_on_message_expiration = var.dead_lettering_on_message_expiration
  enable_partitioning                 = var.enable_partitioning
  requires_duplicate_detection        = var.requires_duplicate_detection
  duplicate_detection_history_time_window = var.duplicate_detection_history_time_window
  requires_session                    = var.requires_session
  enable_batched_operations           = var.enable_batched_operations
  status                              = var.queue_status

  # Forwarding (optional)
  forward_to = var.forward_to
  forward_dead_lettered_messages_to = var.forward_dead_lettered_messages_to

  # Auto-delete on idle
  auto_delete_on_idle = var.auto_delete_on_idle
}

# Authorization Rule for Queue (if needed for connection string)
resource "azurerm_servicebus_queue_authorization_rule" "notification_queue_rule" {
  count    = var.create_queue_authorization_rule ? 1 : 0
  name     = var.queue_authorization_rule_name
  queue_id = azurerm_servicebus_queue.notification_queue.id

  listen = var.queue_rule_listen
  send   = var.queue_rule_send
  manage = var.queue_rule_manage
}

# Namespace Authorization Rule (optional - only if creating a custom rule)
# Note: Azure automatically creates "RootManageSharedAccessKey" with full permissions
# Use default_primary_connection_string from namespace if you don't need a custom rule
resource "azurerm_servicebus_namespace_authorization_rule" "namespace_rule" {
  count    = var.create_namespace_authorization_rule && var.namespace_authorization_rule_name != "RootManageSharedAccessKey" ? 1 : 0
  name     = var.namespace_authorization_rule_name
  namespace_id = azurerm_servicebus_namespace.main.id

  listen = var.namespace_rule_listen
  send   = var.namespace_rule_send
  manage = var.namespace_rule_manage
}
