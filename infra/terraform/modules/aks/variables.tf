# Cluster Configuration
variable "cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.cluster_name))
    error_message = "Cluster name must be 1-63 alphanumeric characters or hyphens, all lowercase."
  }
}

variable "location" {
  description = "Azure region for the AKS cluster"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "dns_prefix" {
  description = "DNS prefix for the AKS cluster"
  type        = string
  default     = "aks"
  
  validation {
    condition     = can(regex("^[a-z0-9-]{1,54}$", var.dns_prefix))
    error_message = "DNS prefix must be 1-54 alphanumeric characters or hyphens, all lowercase."
  }
}

variable "kubernetes_version" {
  description = "Kubernetes version for the cluster"
  type        = string
  default     = null # Use latest stable version if not specified
}

# Network Configuration
variable "subnet_id" {
  description = "Subnet ID for the AKS cluster nodes"
  type        = string
  default     = null
}

variable "service_cidr" {
  description = "CIDR for Kubernetes services"
  type        = string
  default     = "10.0.0.0/16"
}

variable "dns_service_ip" {
  description = "IP address for Kubernetes DNS service"
  type        = string
  default     = "10.0.0.10"
}

variable "docker_bridge_cidr" {
  description = "CIDR for Docker bridge network"
  type        = string
  default     = "172.17.0.1/16"
}

variable "enable_network_policy" {
  description = "Enable network policy (Calico)"
  type        = bool
  default     = false
}

# System Node Pool Configuration
variable "system_node_count" {
  description = "Number of nodes in the system node pool"
  type        = number
  default     = 1
  
  validation {
    condition     = var.system_node_count >= 1 && var.system_node_count <= 10
    error_message = "System node count must be between 1 and 10."
  }
}

variable "system_node_vm_size" {
  description = "VM size for system node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "system_node_disk_size" {
  description = "Disk size in GB for system nodes"
  type        = number
  default     = 128
  
  validation {
    condition     = var.system_node_disk_size >= 30 && var.system_node_disk_size <= 2048
    error_message = "System node disk size must be between 30 and 2048 GB."
  }
}

variable "system_node_taints" {
  description = "Taints for system node pool"
  type        = list(string)
  default     = ["CriticalAddonsOnly=true:NoSchedule"]
}

# User Node Pool Configuration
variable "user_node_count" {
  description = "Number of nodes in the user node pool"
  type        = number
  default     = 2
  
  validation {
    condition     = var.user_node_count >= 1 && var.user_node_count <= 100
    error_message = "User node count must be between 1 and 100."
  }
}

variable "user_node_min_count" {
  description = "Minimum number of nodes in user pool (for autoscaling)"
  type        = number
  default     = 2
}

variable "user_node_max_count" {
  description = "Maximum number of nodes in user pool (for autoscaling)"
  type        = number
  default     = 3
}

variable "user_node_vm_size" {
  description = "VM size for user node pool"
  type        = string
  default     = "Standard_DS2_v2"
}

variable "user_node_disk_size" {
  description = "Disk size in GB for user nodes"
  type        = number
  default     = 128
  
  validation {
    condition     = var.user_node_disk_size >= 30 && var.user_node_disk_size <= 2048
    error_message = "User node disk size must be between 30 and 2048 GB."
  }
}

variable "enable_user_pool_autoscaling" {
  description = "Enable autoscaling for user node pool"
  type        = bool
  default     = true
}

variable "user_node_labels" {
  description = "Labels for user node pool"
  type        = map(string)
  default     = {}
}

variable "user_node_taints" {
  description = "Taints for user node pool"
  type        = list(string)
  default     = []
}

# RBAC Configuration
variable "enable_azure_rbac" {
  description = "Enable Azure RBAC for Kubernetes authorization"
  type        = bool
  default     = true
}

variable "admin_group_object_ids" {
  description = "Azure AD group object IDs for cluster admin access"
  type        = list(string)
  default     = []
}

# Azure Monitor Configuration
variable "enable_azure_monitor" {
  description = "Enable Azure Monitor (Container Insights)"
  type        = bool
  default     = true
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics workspace ID for Azure Monitor"
  type        = string
  default     = null
}

# API Server Configuration
variable "api_server_authorized_ip_ranges" {
  description = "Authorized IP ranges for API server access"
  type        = list(string)
  default     = []
}

# Upgrade Configuration
variable "automatic_channel_upgrade" {
  description = "Automatic upgrade channel (patch, rapid, node-image, stable, none)"
  type        = string
  default     = "stable"
  
  validation {
    condition     = contains(["patch", "rapid", "node-image", "stable", "none"], var.automatic_channel_upgrade)
    error_message = "Automatic channel upgrade must be one of: patch, rapid, node-image, stable, none."
  }
}

# Addon Configuration
variable "enable_http_application_routing" {
  description = "Enable HTTP application routing addon"
  type        = bool
  default     = false
}

# Service Principal (Alternative to Managed Identity)
variable "service_principal_client_id" {
  description = "Service principal client ID (if not using managed identity)"
  type        = string
  default     = null
  sensitive   = true
}

variable "service_principal_client_secret" {
  description = "Service principal client secret (if not using managed identity)"
  type        = string
  default     = null
  sensitive   = true
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
