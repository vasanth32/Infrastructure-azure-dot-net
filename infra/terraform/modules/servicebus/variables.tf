# Required Variables
variable "namespace_name" {
  description = "Name of the Service Bus namespace"
  type        = string
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{6,50}$", var.namespace_name))
    error_message = "Namespace name must be 6-50 alphanumeric characters or hyphens."
  }
}

variable "location" {
  description = "Azure region for the Service Bus namespace"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Namespace Configuration
variable "sku" {
  description = "SKU for the Service Bus namespace (Basic, Standard, Premium)"
  type        = string
  default     = "Standard"
  
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "SKU must be one of: Basic, Standard, Premium."
  }
}

variable "capacity" {
  description = "Capacity units for Premium SKU (1, 2, 4, 8, 16)"
  type        = number
  default     = null
  
  validation {
    condition     = var.capacity == null || contains([1, 2, 4, 8, 16], var.capacity)
    error_message = "Capacity must be one of: 1, 2, 4, 8, 16 (only for Premium SKU)."
  }
}

variable "zone_redundant" {
  description = "Enable zone redundancy (Premium SKU only)"
  type        = bool
  default     = false
}

variable "identity_type" {
  description = "Type of managed identity (SystemAssigned, UserAssigned, SystemAssignedUserAssigned, None)"
  type        = string
  default     = "SystemAssigned"
  
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssignedUserAssigned", "None"], var.identity_type)
    error_message = "Identity type must be one of: SystemAssigned, UserAssigned, SystemAssignedUserAssigned, None."
  }
}

variable "local_auth_enabled" {
  description = "Enable local authentication (connection strings)"
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version (1.0, 1.2)"
  type        = string
  default     = "1.2"
  
  validation {
    condition     = contains(["1.0", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be 1.0 or 1.2."
  }
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

# Queue Configuration
variable "queue_name" {
  description = "Name of the notification queue"
  type        = string
  default     = "notification-queue"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,260}$", var.queue_name))
    error_message = "Queue name must be 1-260 alphanumeric characters or hyphens."
  }
}

variable "max_delivery_count" {
  description = "Maximum number of delivery attempts before message is dead-lettered"
  type        = number
  default     = 10
  
  validation {
    condition     = var.max_delivery_count >= 1 && var.max_delivery_count <= 2147483647
    error_message = "Max delivery count must be between 1 and 2147483647."
  }
}

variable "max_size_in_megabytes" {
  description = "Maximum size of the queue in megabytes"
  type        = number
  default     = 1024
  
  validation {
    condition     = var.max_size_in_megabytes >= 1024 && var.max_size_in_megabytes <= 5120
    error_message = "Max size must be between 1024 and 5120 MB (Standard) or 80 GB (Premium)."
  }
}

variable "default_message_ttl" {
  description = "Default message time-to-live (ISO 8601 duration, e.g., PT1H for 1 hour)"
  type        = string
  default     = "P10675199DT2H48M5.4775807S" # Maximum TTL
}

variable "lock_duration" {
  description = "Lock duration for messages (ISO 8601 duration, e.g., PT30S for 30 seconds)"
  type        = string
  default     = "PT1M" # 1 minute
}

variable "dead_lettering_on_message_expiration" {
  description = "Enable dead lettering on message expiration"
  type        = bool
  default     = true
}

variable "enable_partitioning" {
  description = "Enable partitioning (only for Standard SKU, not Premium)"
  type        = bool
  default     = false
}

variable "requires_duplicate_detection" {
  description = "Enable duplicate detection"
  type        = bool
  default     = false
}

variable "duplicate_detection_history_time_window" {
  description = "Time window for duplicate detection (ISO 8601 duration)"
  type        = string
  default     = "PT10M" # 10 minutes
}

variable "requires_session" {
  description = "Enable sessions (ordered message processing)"
  type        = bool
  default     = false
}

variable "enable_batched_operations" {
  description = "Enable batched operations"
  type        = bool
  default     = true
}

variable "queue_status" {
  description = "Queue status (Active, Disabled, SendDisabled, ReceiveDisabled)"
  type        = string
  default     = "Active"
  
  validation {
    condition     = contains(["Active", "Disabled", "SendDisabled", "ReceiveDisabled"], var.queue_status)
    error_message = "Queue status must be one of: Active, Disabled, SendDisabled, ReceiveDisabled."
  }
}

variable "forward_to" {
  description = "Queue or topic to forward messages to"
  type        = string
  default     = null
}

variable "forward_dead_lettered_messages_to" {
  description = "Queue or topic to forward dead-lettered messages to"
  type        = string
  default     = null
}

variable "auto_delete_on_idle" {
  description = "Auto-delete queue on idle (ISO 8601 duration)"
  type        = string
  default     = "P10675199DT2H48M5.4775807S" # Maximum (effectively disabled)
}

# Authorization Rule Configuration
variable "create_namespace_authorization_rule" {
  description = "Create namespace-level authorization rule"
  type        = bool
  default     = true
}

variable "namespace_authorization_rule_name" {
  description = "Name of the namespace authorization rule"
  type        = string
  default     = "RootManageSharedAccessKey"
}

variable "namespace_rule_listen" {
  description = "Grant listen permission on namespace"
  type        = bool
  default     = true
}

variable "namespace_rule_send" {
  description = "Grant send permission on namespace"
  type        = bool
  default     = true
}

variable "namespace_rule_manage" {
  description = "Grant manage permission on namespace"
  type        = bool
  default     = true
}

variable "create_queue_authorization_rule" {
  description = "Create queue-level authorization rule"
  type        = bool
  default     = false
}

variable "queue_authorization_rule_name" {
  description = "Name of the queue authorization rule"
  type        = string
  default     = "notification-queue-rule"
}

variable "queue_rule_listen" {
  description = "Grant listen permission on queue"
  type        = bool
  default     = true
}

variable "queue_rule_send" {
  description = "Grant send permission on queue"
  type        = bool
  default     = true
}

variable "queue_rule_manage" {
  description = "Grant manage permission on queue"
  type        = bool
  default     = false
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
