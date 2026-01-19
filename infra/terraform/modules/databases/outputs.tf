# SQL Server Outputs
output "sql_server_id" {
  description = "ID of the SQL Server"
  value       = var.database_type == "sql" ? azurerm_mssql_server.sql_server[0].id : null
}

output "sql_server_name" {
  description = "Name of the SQL Server"
  value       = var.database_type == "sql" ? azurerm_mssql_server.sql_server[0].name : null
}

output "sql_server_fqdn" {
  description = "FQDN of the SQL Server"
  value       = var.database_type == "sql" ? azurerm_mssql_server.sql_server[0].fully_qualified_domain_name : null
}

# SQL Database Outputs
output "product_service_sql_db_id" {
  description = "ID of the ProductService SQL database"
  value       = var.database_type == "sql" ? azurerm_mssql_database.product_service_db[0].id : null
}

output "product_service_sql_db_name" {
  description = "Name of the ProductService SQL database"
  value       = var.database_type == "sql" ? azurerm_mssql_database.product_service_db[0].name : null
}

output "order_service_sql_db_id" {
  description = "ID of the OrderService SQL database"
  value       = var.database_type == "sql" ? azurerm_mssql_database.order_service_db[0].id : null
}

output "order_service_sql_db_name" {
  description = "Name of the OrderService SQL database"
  value       = var.database_type == "sql" ? azurerm_mssql_database.order_service_db[0].name : null
}

# SQL Connection Strings
output "product_service_sql_connection_string" {
  description = "Connection string for ProductService SQL database"
  value = var.database_type == "sql" ? (
    "Server=tcp:${azurerm_mssql_server.sql_server[0].fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.product_service_db[0].name};Persist Security Info=False;User ID=${var.sql_admin_login};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  ) : null
  sensitive = true
}

output "order_service_sql_connection_string" {
  description = "Connection string for OrderService SQL database"
  value = var.database_type == "sql" ? (
    "Server=tcp:${azurerm_mssql_server.sql_server[0].fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.order_service_db[0].name};Persist Security Info=False;User ID=${var.sql_admin_login};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  ) : null
  sensitive = true
}

# PostgreSQL Server Outputs
output "postgres_server_id" {
  description = "ID of the PostgreSQL Flexible Server"
  value       = var.database_type == "postgresql" ? azurerm_postgresql_flexible_server.postgres_server[0].id : null
}

output "postgres_server_name" {
  description = "Name of the PostgreSQL Flexible Server"
  value       = var.database_type == "postgresql" ? azurerm_postgresql_flexible_server.postgres_server[0].name : null
}

output "postgres_server_fqdn" {
  description = "FQDN of the PostgreSQL Flexible Server"
  value       = var.database_type == "postgresql" ? azurerm_postgresql_flexible_server.postgres_server[0].fqdn : null
}

# PostgreSQL Database Outputs
output "product_service_postgres_db_id" {
  description = "ID of the ProductService PostgreSQL database"
  value       = var.database_type == "postgresql" ? azurerm_postgresql_flexible_server_database.product_service_db[0].id : null
}

output "product_service_postgres_db_name" {
  description = "Name of the ProductService PostgreSQL database"
  value       = var.database_type == "postgresql" ? azurerm_postgresql_flexible_server_database.product_service_db[0].name : null
}

output "order_service_postgres_db_id" {
  description = "ID of the OrderService PostgreSQL database"
  value       = var.database_type == "postgresql" ? azurerm_postgresql_flexible_server_database.order_service_db[0].id : null
}

output "order_service_postgres_db_name" {
  description = "Name of the OrderService PostgreSQL database"
  value       = var.database_type == "postgresql" ? azurerm_postgresql_flexible_server_database.order_service_db[0].name : null
}

# PostgreSQL Connection Strings
output "product_service_postgres_connection_string" {
  description = "Connection string for ProductService PostgreSQL database"
  value = var.database_type == "postgresql" ? (
    "Host=${azurerm_postgresql_flexible_server.postgres_server[0].fqdn};Port=5432;Database=${azurerm_postgresql_flexible_server_database.product_service_db[0].name};Username=${var.postgres_admin_login};Password=${var.postgres_admin_password};SSL Mode=Require;"
  ) : null
  sensitive = true
}

output "order_service_postgres_connection_string" {
  description = "Connection string for OrderService PostgreSQL database"
  value = var.database_type == "postgresql" ? (
    "Host=${azurerm_postgresql_flexible_server.postgres_server[0].fqdn};Port=5432;Database=${azurerm_postgresql_flexible_server_database.order_service_db[0].name};Username=${var.postgres_admin_login};Password=${var.postgres_admin_password};SSL Mode=Require;"
  ) : null
  sensitive = true
}

# Generic Connection String Outputs (for convenience)
output "product_service_connection_string" {
  description = "Connection string for ProductService database (SQL or PostgreSQL)"
  value = var.database_type == "sql" ? (
    "Server=tcp:${azurerm_mssql_server.sql_server[0].fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.product_service_db[0].name};Persist Security Info=False;User ID=${var.sql_admin_login};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  ) : (
    "Host=${azurerm_postgresql_flexible_server.postgres_server[0].fqdn};Port=5432;Database=${azurerm_postgresql_flexible_server_database.product_service_db[0].name};Username=${var.postgres_admin_login};Password=${var.postgres_admin_password};SSL Mode=Require;"
  )
  sensitive = true
}

output "order_service_connection_string" {
  description = "Connection string for OrderService database (SQL or PostgreSQL)"
  value = var.database_type == "sql" ? (
    "Server=tcp:${azurerm_mssql_server.sql_server[0].fully_qualified_domain_name},1433;Initial Catalog=${azurerm_mssql_database.order_service_db[0].name};Persist Security Info=False;User ID=${var.sql_admin_login};Password=${var.sql_admin_password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;"
  ) : (
    "Host=${azurerm_postgresql_flexible_server.postgres_server[0].fqdn};Port=5432;Database=${azurerm_postgresql_flexible_server_database.order_service_db[0].name};Username=${var.postgres_admin_login};Password=${var.postgres_admin_password};SSL Mode=Require;"
  )
  sensitive = true
}

# Database Names (for Key Vault storage)
output "product_service_db_name" {
  description = "Name of the ProductService database"
  value       = var.product_service_db_name
}

output "order_service_db_name" {
  description = "Name of the OrderService database"
  value       = var.order_service_db_name
}

# Identity Information
output "sql_server_identity" {
  description = "Managed identity of the SQL Server"
  value = var.database_type == "sql" && length(azurerm_mssql_server.sql_server[0].identity) > 0 ? {
    principal_id = azurerm_mssql_server.sql_server[0].identity[0].principal_id
    tenant_id    = azurerm_mssql_server.sql_server[0].identity[0].tenant_id
  } : null
}

output "postgres_server_identity" {
  description = "Managed identity of the PostgreSQL Server"
  value = var.database_type == "postgresql" && length(azurerm_postgresql_flexible_server.postgres_server[0].identity) > 0 ? {
    type = azurerm_postgresql_flexible_server.postgres_server[0].identity[0].type
    # Note: PostgreSQL flexible server identity doesn't expose principal_id/tenant_id directly
    # Use the server's identity for role assignments via the server resource ID
  } : null
}

# Private Endpoint Information
output "sql_private_endpoint_id" {
  description = "ID of the SQL Server private endpoint (if enabled)"
  value       = var.database_type == "sql" && var.enable_private_endpoint ? azurerm_private_endpoint.sql_server_private_endpoint[0].id : null
}
