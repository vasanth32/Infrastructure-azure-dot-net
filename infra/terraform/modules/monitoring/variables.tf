# Required Variables
variable "location" {
  description = "Azure region for the monitoring resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Log Analytics Workspace Configuration
variable "log_analytics_workspace_name" {
  description = "Name of the Log Analytics workspace"
  type        = string
  default     = "law-microservices-poc"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{4,63}$", var.log_analytics_workspace_name))
    error_message = "Log Analytics workspace name must be 4-63 alphanumeric characters or hyphens."
  }
}

variable "log_analytics_sku" {
  description = "SKU for Log Analytics workspace (PerGB2018, CapacityReservation, Free, PerNode, Premium, Standard, Standalone)"
  type        = string
  default     = "PerGB2018"
  
  validation {
    condition     = contains(["PerGB2018", "CapacityReservation", "Free", "PerNode", "Premium", "Standard", "Standalone"], var.log_analytics_sku)
    error_message = "Log Analytics SKU must be one of: PerGB2018, CapacityReservation, Free, PerNode, Premium, Standard, Standalone."
  }
}

variable "log_analytics_retention_days" {
  description = "Data retention in days (30, 31, 60, 90, 120, 180, 270, 365, 550, 730, or 1095)"
  type        = number
  default     = 30
  
  validation {
    condition     = contains([30, 31, 60, 90, 120, 180, 270, 365, 550, 730, 1095], var.log_analytics_retention_days)
    error_message = "Retention days must be one of: 30, 31, 60, 90, 120, 180, 270, 365, 550, 730, 1095."
  }
}

variable "log_analytics_daily_quota_gb" {
  description = "Daily quota in GB (null = unlimited)"
  type        = number
  default     = null
}

variable "log_analytics_internet_ingestion_enabled" {
  description = "Enable internet ingestion"
  type        = bool
  default     = true
}

variable "log_analytics_internet_query_enabled" {
  description = "Enable internet query access"
  type        = bool
  default     = true
}

# Application Insights Configuration
variable "application_insights_mode" {
  description = "Application Insights deployment mode: 'shared' (one for all services) or 'per-service' (one per service)"
  type        = string
  default     = "shared"
  
  validation {
    condition     = contains(["shared", "per-service"], var.application_insights_mode)
    error_message = "Application Insights mode must be either 'shared' or 'per-service'."
  }
}

variable "application_insights_type" {
  description = "Application Insights application type (web, other, java, MobileCenter, Store, Universal, Node.JS, Phone, Store, UWP)"
  type        = string
  default     = "web"
  
  validation {
    condition     = contains(["web", "other", "java", "MobileCenter", "Store", "Universal", "Node.JS", "Phone", "Store", "UWP"], var.application_insights_type)
    error_message = "Application Insights type must be a valid application type."
  }
}

variable "application_insights_retention_days" {
  description = "Data retention in days (30, 60, 90, 120, 180, 270, 365, or 730)"
  type        = number
  default     = 90
  
  validation {
    condition     = contains([30, 60, 90, 120, 180, 270, 365, 730], var.application_insights_retention_days)
    error_message = "Application Insights retention days must be one of: 30, 60, 90, 120, 180, 270, 365, 730."
  }
}

variable "application_insights_daily_data_cap_gb" {
  description = "Daily data cap in GB (null = unlimited)"
  type        = number
  default     = null
}

variable "application_insights_sampling_percentage" {
  description = "Sampling percentage (0-100, null = disabled)"
  type        = number
  default     = null
  
  validation {
    condition     = var.application_insights_sampling_percentage == null || (var.application_insights_sampling_percentage >= 0 && var.application_insights_sampling_percentage <= 100)
    error_message = "Sampling percentage must be between 0 and 100, or null to disable."
  }
}

variable "application_insights_disable_ip_masking" {
  description = "Disable IP masking (show full IP addresses)"
  type        = bool
  default     = false
}

# Shared Application Insights Name
variable "shared_application_insights_name" {
  description = "Name of the shared Application Insights instance"
  type        = string
  default     = "appi-microservices-poc"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,260}$", var.shared_application_insights_name))
    error_message = "Application Insights name must be 1-260 alphanumeric characters or hyphens."
  }
}

# Per-Service Application Insights Names
variable "product_service_application_insights_name" {
  description = "Name of the ProductService Application Insights instance"
  type        = string
  default     = "appi-productservice-poc"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,260}$", var.product_service_application_insights_name))
    error_message = "Application Insights name must be 1-260 alphanumeric characters or hyphens."
  }
}

variable "order_service_application_insights_name" {
  description = "Name of the OrderService Application Insights instance"
  type        = string
  default     = "appi-orderservice-poc"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,260}$", var.order_service_application_insights_name))
    error_message = "Application Insights name must be 1-260 alphanumeric characters or hyphens."
  }
}

variable "notification_service_application_insights_name" {
  description = "Name of the NotificationService Application Insights instance"
  type        = string
  default     = "appi-notificationservice-poc"
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-]{1,260}$", var.notification_service_application_insights_name))
    error_message = "Application Insights name must be 1-260 alphanumeric characters or hyphens."
  }
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
