# Database Type Selection
variable "database_type" {
  description = "Type of database to deploy (sql or postgresql)"
  type        = string
  default     = "sql"
  
  validation {
    condition     = contains(["sql", "postgresql"], var.database_type)
    error_message = "Database type must be either 'sql' or 'postgresql'."
  }
}

variable "location" {
  description = "Azure region for the database resources"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

# Database Names
variable "product_service_db_name" {
  description = "Name of the ProductService database"
  type        = string
  default     = "ProductServiceDB"
}

variable "order_service_db_name" {
  description = "Name of the OrderService database"
  type        = string
  default     = "OrderServiceDB"
}

# SQL Server Configuration
variable "sql_server_name" {
  description = "Name of the SQL Server"
  type        = string
  default     = "sql-microservices-poc"
  
  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.sql_server_name))
    error_message = "SQL Server name must be 1-63 alphanumeric characters or hyphens, all lowercase."
  }
}

variable "sql_server_version" {
  description = "SQL Server version"
  type        = string
  default     = "12.0" # SQL Server 2014 or later
}

variable "sql_admin_login" {
  description = "SQL Server administrator login"
  type        = string
  default     = "sqladmin"
  sensitive   = true
}

variable "sql_admin_password" {
  description = "SQL Server administrator password"
  type        = string
  sensitive   = true
  
  validation {
    condition     = length(var.sql_admin_password) >= 8 && length(var.sql_admin_password) <= 128
    error_message = "SQL admin password must be between 8 and 128 characters."
  }
}

variable "sql_identity_type" {
  description = "Type of managed identity for SQL Server"
  type        = string
  default     = "SystemAssigned"
  
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned", "SystemAssignedUserAssigned"], var.sql_identity_type)
    error_message = "SQL identity type must be one of: SystemAssigned, UserAssigned, SystemAssignedUserAssigned."
  }
}

variable "sql_azuread_admin_login" {
  description = "Azure AD admin login for SQL Server"
  type        = string
  default     = null
}

variable "sql_azuread_admin_object_id" {
  description = "Azure AD admin object ID"
  type        = string
  default     = null
}

variable "sql_azuread_admin_tenant_id" {
  description = "Azure AD admin tenant ID"
  type        = string
  default     = null
}

variable "sql_minimum_tls_version" {
  description = "Minimum TLS version for SQL Server"
  type        = string
  default     = "1.2"
  
  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.sql_minimum_tls_version)
    error_message = "Minimum TLS version must be 1.0, 1.1, or 1.2."
  }
}

variable "sql_public_network_access_enabled" {
  description = "Enable public network access for SQL Server"
  type        = bool
  default     = true
}

variable "sql_connection_policy" {
  description = "Connection policy (Default, Proxy, Redirect)"
  type        = string
  default     = "Default"
  
  validation {
    condition     = contains(["Default", "Proxy", "Redirect"], var.sql_connection_policy)
    error_message = "Connection policy must be one of: Default, Proxy, Redirect."
  }
}

variable "sql_tde_key_vault_key_id" {
  description = "Key Vault key ID for Transparent Data Encryption"
  type        = string
  default     = null
}

variable "sql_collation" {
  description = "Database collation"
  type        = string
  default     = "SQL_Latin1_General_CP1_CI_AS"
}

variable "sql_license_type" {
  description = "License type (LicenseIncluded or BasePrice)"
  type        = string
  default     = "LicenseIncluded"
  
  validation {
    condition     = contains(["LicenseIncluded", "BasePrice"], var.sql_license_type)
    error_message = "License type must be LicenseIncluded or BasePrice."
  }
}

variable "sql_max_size_gb" {
  description = "Maximum size of the database in GB"
  type        = number
  default     = 32
}

variable "sql_sku_name" {
  description = "SKU name for SQL database (e.g., Basic, S0, P1, etc.)"
  type        = string
  default     = "Basic"
}

variable "sql_zone_redundant" {
  description = "Enable zone redundancy for SQL database"
  type        = bool
  default     = false
}

variable "sql_backup_retention_days" {
  description = "Backup retention in days"
  type        = number
  default     = 7
  
  validation {
    condition     = var.sql_backup_retention_days >= 7 && var.sql_backup_retention_days <= 35
    error_message = "Backup retention must be between 7 and 35 days."
  }
}

variable "sql_long_term_weekly_retention" {
  description = "Long-term backup weekly retention"
  type        = string
  default     = null
}

variable "sql_long_term_monthly_retention" {
  description = "Long-term backup monthly retention"
  type        = string
  default     = null
}

variable "sql_long_term_yearly_retention" {
  description = "Long-term backup yearly retention"
  type        = string
  default     = null
}

variable "sql_long_term_week_of_year" {
  description = "Week of year for long-term backup"
  type        = number
  default     = null
}

variable "sql_geo_backup_enabled" {
  description = "Enable geo-backup"
  type        = bool
  default     = true
}

variable "sql_allow_azure_services" {
  description = "Allow Azure services to access SQL Server"
  type        = bool
  default     = true
}

variable "sql_firewall_rules" {
  description = "Custom firewall rules for SQL Server"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

# PostgreSQL Configuration
variable "postgres_server_name" {
  description = "Name of the PostgreSQL Flexible Server"
  type        = string
  default     = "postgres-microservices-poc"
  
  validation {
    condition     = can(regex("^[a-z0-9-]{1,63}$", var.postgres_server_name))
    error_message = "PostgreSQL server name must be 1-63 alphanumeric characters or hyphens, all lowercase."
  }
}

variable "postgres_version" {
  description = "PostgreSQL version"
  type        = string
  default     = "14"
  
  validation {
    condition     = contains(["11", "12", "13", "14", "15", "16"], var.postgres_version)
    error_message = "PostgreSQL version must be 11, 12, 13, 14, 15, or 16."
  }
}

variable "postgres_admin_login" {
  description = "PostgreSQL administrator login"
  type        = string
  default     = "postgresadmin"
  sensitive   = true
}

variable "postgres_admin_password" {
  description = "PostgreSQL administrator password. Only needed if database_type = 'postgresql'"
  type        = string
  default     = ""  # Empty default - only used when database_type = "postgresql"
  sensitive   = true
  
  validation {
    condition     = var.postgres_admin_password == "" || (length(var.postgres_admin_password) >= 8 && length(var.postgres_admin_password) <= 128)
    error_message = "PostgreSQL admin password must be between 8 and 128 characters, or empty if not using PostgreSQL."
  }
}

variable "postgres_sku_name" {
  description = "SKU name for PostgreSQL (e.g., B_Standard_B1ms, GP_Standard_D2s_v3)"
  type        = string
  default     = "B_Standard_B1ms"
}

variable "postgres_storage_mb" {
  description = "Storage size in MB for PostgreSQL"
  type        = number
  default     = 32768 # 32 GB
  
  validation {
    condition     = var.postgres_storage_mb >= 32768 && var.postgres_storage_mb <= 16777216
    error_message = "PostgreSQL storage must be between 32 GB (32768 MB) and 16 TB (16777216 MB)."
  }
}

variable "postgres_backup_retention_days" {
  description = "Backup retention in days for PostgreSQL"
  type        = number
  default     = 7
  
  validation {
    condition     = var.postgres_backup_retention_days >= 7 && var.postgres_backup_retention_days <= 35
    error_message = "PostgreSQL backup retention must be between 7 and 35 days."
  }
}

variable "postgres_ha_mode" {
  description = "High availability mode (SameZone, ZoneRedundant, or null for disabled)"
  type        = string
  default     = null
  
  validation {
    condition     = var.postgres_ha_mode == null || contains(["SameZone", "ZoneRedundant"], var.postgres_ha_mode)
    error_message = "PostgreSQL HA mode must be SameZone, ZoneRedundant, or null."
  }
}

variable "postgres_standby_zone" {
  description = "Standby availability zone for HA"
  type        = number
  default     = null
}

variable "postgres_maintenance_day" {
  description = "Day of week for maintenance (0=Sunday, 6=Saturday)"
  type        = number
  default     = 0
  
  validation {
    condition     = var.postgres_maintenance_day >= 0 && var.postgres_maintenance_day <= 6
    error_message = "Maintenance day must be between 0 (Sunday) and 6 (Saturday)."
  }
}

variable "postgres_maintenance_hour" {
  description = "Hour for maintenance (0-23)"
  type        = number
  default     = 2
  
  validation {
    condition     = var.postgres_maintenance_hour >= 0 && var.postgres_maintenance_hour <= 23
    error_message = "Maintenance hour must be between 0 and 23."
  }
}

variable "postgres_maintenance_minute" {
  description = "Minute for maintenance (0-59)"
  type        = number
  default     = 0
  
  validation {
    condition     = var.postgres_maintenance_minute >= 0 && var.postgres_maintenance_minute <= 59
    error_message = "Maintenance minute must be between 0 and 59."
  }
}

variable "postgres_public_network_access_enabled" {
  description = "Enable public network access for PostgreSQL"
  type        = bool
  default     = true
}

variable "postgres_delegated_subnet_id" {
  description = "Delegated subnet ID for PostgreSQL (for private access)"
  type        = string
  default     = null
}

variable "postgres_private_dns_zone_id" {
  description = "Private DNS zone ID for PostgreSQL"
  type        = string
  default     = null
}

variable "postgres_aad_auth_enabled" {
  description = "Enable Azure AD authentication for PostgreSQL"
  type        = bool
  default     = false
}

variable "postgres_password_auth_enabled" {
  description = "Enable password authentication for PostgreSQL"
  type        = bool
  default     = true
}

variable "postgres_aad_tenant_id" {
  description = "Azure AD tenant ID for PostgreSQL"
  type        = string
  default     = null
}

variable "postgres_identity_type" {
  description = "Type of managed identity for PostgreSQL"
  type        = string
  default     = "SystemAssigned"
  
  validation {
    condition     = contains(["SystemAssigned", "UserAssigned"], var.postgres_identity_type)
    error_message = "PostgreSQL identity type must be SystemAssigned or UserAssigned."
  }
}

variable "postgres_user_assigned_identity_ids" {
  description = "User-assigned identity IDs for PostgreSQL"
  type        = list(string)
  default     = []
}

variable "postgres_charset" {
  description = "Database charset for PostgreSQL"
  type        = string
  default     = "UTF8"
}

variable "postgres_collation" {
  description = "Database collation for PostgreSQL"
  type        = string
  default     = "en_US.utf8"
}

variable "postgres_allow_azure_services" {
  description = "Allow Azure services to access PostgreSQL"
  type        = bool
  default     = true
}

variable "postgres_firewall_rules" {
  description = "Custom firewall rules for PostgreSQL"
  type = map(object({
    start_ip = string
    end_ip   = string
  }))
  default = {}
}

# Private Endpoint Configuration
variable "enable_private_endpoint" {
  description = "Enable private endpoint for SQL Server (PostgreSQL uses delegated subnet)"
  type        = bool
  default     = false
}

variable "private_endpoint_subnet_id" {
  description = "Subnet ID for private endpoint"
  type        = string
  default     = null
}

variable "private_dns_zone_ids" {
  description = "Private DNS zone IDs for private endpoint"
  type        = list(string)
  default     = []
}

# Tags
variable "tags" {
  description = "Tags to apply to all resources"
  type        = map(string)
  default     = {}
}
