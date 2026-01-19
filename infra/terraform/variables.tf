variable "location" {
  description = "Azure region for resources"
  type        = string
  default     = "eastus"
  
  validation {
    condition = contains([
      "eastus", "eastus2", "westus", "westus2", 
      "centralus", "northcentralus", "southcentralus",
      "westcentralus", "canadacentral", "canadaeast"
    ], var.location)
    error_message = "Location must be a valid Azure region."
  }
}

variable "environment" {
  description = "Environment name (dev, staging, prod)"
  type        = string
  default     = "dev"
  
  validation {
    condition     = contains(["dev", "staging", "prod"], var.environment)
    error_message = "Environment must be one of: dev, staging, prod."
  }
}

variable "resource_group_name" {
  description = "Name of the resource group (if not provided, will use rg-{environment}-microservices-poc)"
  type        = string
  default     = null
}

variable "acr_name" {
  description = "Name of the Azure Container Registry"
  type        = string
  
  validation {
    condition     = can(regex("^[a-z0-9]{5,50}$", var.acr_name))
    error_message = "ACR name must be 5-50 alphanumeric characters, all lowercase."
  }
}

variable "aks_cluster_name" {
  description = "Name of the AKS cluster"
  type        = string
  default     = "aks-microservices-poc"
  
  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.aks_cluster_name))
    error_message = "AKS cluster name must be 1-63 alphanumeric characters or hyphens, all lowercase."
  }
}

variable "aks_subnet_id" {
  description = "Subnet ID for AKS cluster (null = AKS will create its own VNet)"
  type        = string
  default     = null
}

variable "database_type" {
  description = "Database type: 'sql' or 'postgresql'"
  type        = string
  default     = "sql"
  
  validation {
    condition     = contains(["sql", "postgresql"], var.database_type)
    error_message = "Database type must be either 'sql' or 'postgresql'."
  }
}

variable "sql_admin_login" {
  description = "SQL Server administrator login"
  type        = string
  default     = "sqladmin"
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL Server administrator password (min 8 characters, must contain uppercase, lowercase, numbers, and special characters)"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.sql_admin_password) >= 8 && length(var.sql_admin_password) <= 128
    error_message = "SQL admin password must be between 8 and 128 characters."
  }
}

variable "postgres_admin_login" {
  description = "PostgreSQL administrator login"
  type        = string
  default     = "postgresadmin"
  sensitive   = true
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password (min 8 characters, must contain uppercase, lowercase, numbers, and special characters). Only needed if database_type = 'postgresql'"
  type        = string
  default     = ""  # Empty default - only used when database_type = "postgresql"
  sensitive   = true
  
  validation {
    condition     = var.postgres_admin_password == "" || (length(var.postgres_admin_password) >= 8 && length(var.postgres_admin_password) <= 128)
    error_message = "PostgreSQL admin password must be between 8 and 128 characters, or empty if not using PostgreSQL."
  }
}

# Optional: Service Principal variables (uncomment if needed)
# variable "subscription_id" {
#   description = "Azure subscription ID"
#   type        = string
#   sensitive   = true
# }

# variable "client_id" {
#   description = "Azure service principal client ID"
#   type        = string
#   sensitive   = true
# }

# variable "client_secret" {
#   description = "Azure service principal client secret"
#   type        = string
#   sensitive   = true
# }

# variable "tenant_id" {
#   description = "Azure tenant ID"
#   type        = string
#   sensitive   = true
# }
