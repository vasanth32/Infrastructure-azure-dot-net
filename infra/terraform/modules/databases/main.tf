# Azure SQL Server (if database_type is "sql")
resource "azurerm_mssql_server" "sql_server" {
  count                        = var.database_type == "sql" ? 1 : 0
  name                         = var.sql_server_name
  resource_group_name          = var.resource_group_name
  location                     = var.location
  version                      = var.sql_server_version
  administrator_login          = var.sql_admin_login
  administrator_login_password = var.sql_admin_password

  # Identity
  identity {
    type = var.sql_identity_type
  }

  # Azure AD admin (only if all values are provided)
  dynamic "azuread_administrator" {
    for_each = var.sql_azuread_admin_login != null && var.sql_azuread_admin_object_id != null && var.sql_azuread_admin_tenant_id != null ? [1] : []
    content {
      login_username = var.sql_azuread_admin_login
      object_id      = var.sql_azuread_admin_object_id
      tenant_id      = var.sql_azuread_admin_tenant_id
    }
  }

  # Security settings
  minimum_tls_version                 = var.sql_minimum_tls_version
  public_network_access_enabled        = var.sql_public_network_access_enabled
  connection_policy                    = var.sql_connection_policy
  transparent_data_encryption_key_vault_key_id = var.sql_tde_key_vault_key_id

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      DatabaseType = "SQL"
    }
  )
}

# ProductService SQL Database
resource "azurerm_mssql_database" "product_service_db" {
  count           = var.database_type == "sql" ? 1 : 0
  name            = var.product_service_db_name
  server_id       = azurerm_mssql_server.sql_server[0].id
  collation       = var.sql_collation
  license_type    = var.sql_license_type
  # Basic tier max size is 2GB, adjust if using Basic
  max_size_gb     = var.sql_sku_name == "Basic" ? min(var.sql_max_size_gb, 2) : var.sql_max_size_gb
  sku_name        = var.sql_sku_name
  zone_redundant  = var.sql_zone_redundant

  # Backup settings
  short_term_retention_policy {
    retention_days = var.sql_backup_retention_days
  }

  # Long-term retention (optional - only if at least one value is provided)
  dynamic "long_term_retention_policy" {
    for_each = var.sql_long_term_weekly_retention != null || var.sql_long_term_monthly_retention != null || var.sql_long_term_yearly_retention != null || var.sql_long_term_week_of_year != null ? [1] : []
    content {
      weekly_retention  = var.sql_long_term_weekly_retention
      monthly_retention = var.sql_long_term_monthly_retention
      yearly_retention  = var.sql_long_term_yearly_retention
      week_of_year      = var.sql_long_term_week_of_year
    }
  }

  # Geo-replication (optional)
  geo_backup_enabled = var.sql_geo_backup_enabled

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Service   = "ProductService"
    }
  )
}

# OrderService SQL Database
resource "azurerm_mssql_database" "order_service_db" {
  count           = var.database_type == "sql" ? 1 : 0
  name            = var.order_service_db_name
  server_id       = azurerm_mssql_server.sql_server[0].id
  collation       = var.sql_collation
  license_type    = var.sql_license_type
  # Basic tier max size is 2GB, adjust if using Basic
  max_size_gb     = var.sql_sku_name == "Basic" ? min(var.sql_max_size_gb, 2) : var.sql_max_size_gb
  sku_name        = var.sql_sku_name
  zone_redundant  = var.sql_zone_redundant

  # Backup settings
  short_term_retention_policy {
    retention_days = var.sql_backup_retention_days
  }

  # Long-term retention (optional - only if at least one value is provided)
  dynamic "long_term_retention_policy" {
    for_each = var.sql_long_term_weekly_retention != null || var.sql_long_term_monthly_retention != null || var.sql_long_term_yearly_retention != null || var.sql_long_term_week_of_year != null ? [1] : []
    content {
      weekly_retention  = var.sql_long_term_weekly_retention
      monthly_retention = var.sql_long_term_monthly_retention
      yearly_retention  = var.sql_long_term_yearly_retention
      week_of_year      = var.sql_long_term_week_of_year
    }
  }

  # Geo-replication (optional)
  geo_backup_enabled = var.sql_geo_backup_enabled

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Service   = "OrderService"
    }
  )
}

# SQL Server Firewall Rules
resource "azurerm_mssql_firewall_rule" "allow_azure_services" {
  count            = var.database_type == "sql" && var.sql_allow_azure_services ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_mssql_server.sql_server[0].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_mssql_firewall_rule" "custom_rules" {
  for_each = var.database_type == "sql" ? var.sql_firewall_rules : {}

  name             = each.key
  server_id        = azurerm_mssql_server.sql_server[0].id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}

# SQL Server Private Endpoint (optional)
resource "azurerm_private_endpoint" "sql_server_private_endpoint" {
  count               = var.database_type == "sql" && var.enable_private_endpoint ? 1 : 0
  name                = "${var.sql_server_name}-pe"
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.private_endpoint_subnet_id

  private_service_connection {
    name                           = "${var.sql_server_name}-psc"
    private_connection_resource_id = azurerm_mssql_server.sql_server[0].id
    subresource_names              = ["sqlServer"]
    is_manual_connection           = false
  }

  private_dns_zone_group {
    name                 = "sql-server-dns-zone"
    private_dns_zone_ids = var.private_dns_zone_ids
  }

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

# PostgreSQL Flexible Server
resource "azurerm_postgresql_flexible_server" "postgres_server" {
  count                  = var.database_type == "postgresql" ? 1 : 0
  name                   = var.postgres_server_name
  resource_group_name    = var.resource_group_name
  location               = var.location
  version                = var.postgres_version
  administrator_login    = var.postgres_admin_login
  administrator_password = var.postgres_admin_password

  # SKU
  sku_name = var.postgres_sku_name

  # Storage
  storage_mb = var.postgres_storage_mb
  backup_retention_days = var.postgres_backup_retention_days

  # High availability
  high_availability {
    mode                      = var.postgres_ha_mode
    standby_availability_zone = var.postgres_standby_zone
  }

  # Maintenance
  maintenance_window {
    day_of_week  = var.postgres_maintenance_day
    start_hour   = var.postgres_maintenance_hour
    start_minute = var.postgres_maintenance_minute
  }

  # Network
  public_network_access_enabled = var.postgres_public_network_access_enabled
  delegated_subnet_id           = var.postgres_delegated_subnet_id
  private_dns_zone_id           = var.postgres_private_dns_zone_id

  # Authentication
  authentication {
    active_directory_auth_enabled = var.postgres_aad_auth_enabled
    password_auth_enabled         = var.postgres_password_auth_enabled
    tenant_id                     = var.postgres_aad_tenant_id
  }

  # Identity
  identity {
    type         = var.postgres_identity_type
    identity_ids = var.postgres_user_assigned_identity_ids
  }

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy   = "Terraform"
      DatabaseType = "PostgreSQL"
    }
  )
}

# ProductService PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "product_service_db" {
  count     = var.database_type == "postgresql" ? 1 : 0
  name      = var.product_service_db_name
  server_id = azurerm_postgresql_flexible_server.postgres_server[0].id
  charset   = var.postgres_charset
  collation = var.postgres_collation

  # Note: PostgreSQL databases don't support tags
}

# OrderService PostgreSQL Database
resource "azurerm_postgresql_flexible_server_database" "order_service_db" {
  count     = var.database_type == "postgresql" ? 1 : 0
  name      = var.order_service_db_name
  server_id = azurerm_postgresql_flexible_server.postgres_server[0].id
  charset   = var.postgres_charset
  collation = var.postgres_collation

  # Note: PostgreSQL databases don't support tags
}

# PostgreSQL Firewall Rules
resource "azurerm_postgresql_flexible_server_firewall_rule" "allow_azure_services" {
  count            = var.database_type == "postgresql" && var.postgres_allow_azure_services ? 1 : 0
  name             = "AllowAzureServices"
  server_id        = azurerm_postgresql_flexible_server.postgres_server[0].id
  start_ip_address = "0.0.0.0"
  end_ip_address   = "0.0.0.0"
}

resource "azurerm_postgresql_flexible_server_firewall_rule" "custom_rules" {
  for_each = var.database_type == "postgresql" ? var.postgres_firewall_rules : {}

  name             = each.key
  server_id        = azurerm_postgresql_flexible_server.postgres_server[0].id
  start_ip_address = each.value.start_ip
  end_ip_address   = each.value.end_ip
}
