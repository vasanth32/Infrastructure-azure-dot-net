# Databases Module

This Terraform module creates Azure SQL Server or PostgreSQL Flexible Server with databases for ProductService and OrderService, including firewall rules and optional private endpoints.

## Features

- **Dual Database Support:** SQL Server or PostgreSQL Flexible Server
- **ProductService Database:** Dedicated database for ProductService
- **OrderService Database:** Dedicated database for OrderService
- **Firewall Rules:** Allow Azure services and custom IP ranges
- **Private Endpoints:** Optional private endpoint configuration
- **Managed Identity:** System-assigned managed identity support
- **Backup Configuration:** Configurable backup retention
- **Connection Strings:** Ready-to-use connection strings for applications

## Usage

### SQL Server Example

```hcl
module "databases" {
  source = "./modules/databases"

  database_type      = "sql"
  location           = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  # SQL Server Configuration
  sql_server_name    = "sql-microservices-poc"
  sql_admin_login    = "sqladmin"
  sql_admin_password = var.sql_admin_password  # From Key Vault or variable

  # Database Names
  product_service_db_name = "ProductServiceDB"
  order_service_db_name   = "OrderServiceDB"

  # Firewall Rules
  sql_allow_azure_services = true
  sql_firewall_rules = {
    "AllowMyIP" = {
      start_ip = "1.2.3.4"
      end_ip   = "1.2.3.4"
    }
  }

  # Optional: Private Endpoint
  enable_private_endpoint = false

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

### PostgreSQL Example

```hcl
module "databases" {
  source = "./modules/databases"

  database_type      = "postgresql"
  location           = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  # PostgreSQL Configuration
  postgres_server_name    = "postgres-microservices-poc"
  postgres_admin_login    = "postgresadmin"
  postgres_admin_password = var.postgres_admin_password

  # Database Names
  product_service_db_name = "ProductServiceDB"
  order_service_db_name   = "OrderServiceDB"

  # Firewall Rules
  postgres_allow_azure_services = true
  postgres_firewall_rules = {
    "AllowMyIP" = {
      start_ip = "1.2.3.4"
      end_ip   = "1.2.3.4"
    }
  }

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | ~> 3.0 |

## Inputs

### Required

| Name | Description | Type | Default |
|------|-------------|------|---------|
| location | Azure region | `string` | n/a |
| resource_group_name | Resource group name | `string` | n/a |

### Optional

| Name | Description | Type | Default |
|------|-------------|------|---------|
| database_type | Database type (sql or postgresql) | `string` | `"sql"` |
| sql_server_name | SQL Server name | `string` | `"sql-microservices-poc"` |
| sql_admin_login | SQL admin login | `string` | `"sqladmin"` |
| sql_admin_password | SQL admin password | `string` | n/a (sensitive) |
| postgres_server_name | PostgreSQL server name | `string` | `"postgres-microservices-poc"` |
| postgres_admin_login | PostgreSQL admin login | `string` | `"postgresadmin"` |
| postgres_admin_password | PostgreSQL admin password | `string` | n/a (sensitive) |
| product_service_db_name | ProductService database name | `string` | `"ProductServiceDB"` |
| order_service_db_name | OrderService database name | `string` | `"OrderServiceDB"` |
| sql_allow_azure_services | Allow Azure services | `bool` | `true` |
| postgres_allow_azure_services | Allow Azure services | `bool` | `true` |
| enable_private_endpoint | Enable private endpoint | `bool` | `false` |
| tags | Resource tags | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| product_service_connection_string | ProductService connection string (sensitive) |
| order_service_connection_string | OrderService connection string (sensitive) |
| product_service_db_name | ProductService database name |
| order_service_db_name | OrderService database name |
| sql_server_fqdn | SQL Server FQDN |
| postgres_server_fqdn | PostgreSQL Server FQDN |

## SQL Server vs PostgreSQL

### SQL Server
- **Best for:** .NET applications, Windows ecosystem
- **Features:** Always Encrypted, Advanced Threat Protection, SQL Agent
- **Pricing:** Pay-as-you-go or reserved capacity
- **SKU Options:** Basic, S0-S12, P1-P15, Business Critical, Hyperscale

### PostgreSQL Flexible Server
- **Best for:** Open-source applications, Linux ecosystem
- **Features:** High availability, read replicas, point-in-time restore
- **Pricing:** Compute + storage
- **SKU Options:** Burstable (B), General Purpose (GP), Memory Optimized (MO)

## Connection Strings

### SQL Server Connection String Format
```
Server=tcp:{server}.database.windows.net,1433;Initial Catalog={database};Persist Security Info=False;User ID={username};Password={password};MultipleActiveResultSets=False;Encrypt=True;TrustServerCertificate=False;Connection Timeout=30;
```

### PostgreSQL Connection String Format
```
Host={server}.postgres.database.azure.com;Port=5432;Database={database};Username={username};Password={password};SSL Mode=Require;
```

## Storing Connection Strings in Key Vault

After creating the databases, store connection strings in Azure Key Vault:

```hcl
# Key Vault Secret for ProductService
resource "azurerm_key_vault_secret" "product_service_db_connection" {
  name         = "ProductService-DB-ConnectionString"
  value        = module.databases.product_service_connection_string
  key_vault_id = azurerm_key_vault.main.id
}

# Key Vault Secret for OrderService
resource "azurerm_key_vault_secret" "order_service_db_connection" {
  name         = "OrderService-DB-ConnectionString"
  value        = module.databases.order_service_connection_string
  key_vault_id = azurerm_key_vault.main.id
}
```

## Using Connection Strings in Applications

### .NET (SQL Server)
```csharp
using Microsoft.Data.SqlClient;

var connectionString = "Server=tcp:...";
using var connection = new SqlConnection(connectionString);
await connection.OpenAsync();
```

### .NET (PostgreSQL)
```csharp
using Npgsql;

var connectionString = "Host=...";
using var connection = new NpgsqlConnection(connectionString);
await connection.OpenAsync();
```

### Entity Framework Core
```csharp
// SQL Server
services.AddDbContext<ProductDbContext>(options =>
    options.UseSqlServer(connectionString));

// PostgreSQL
services.AddDbContext<ProductDbContext>(options =>
    options.UseNpgsql(connectionString));
```

## Firewall Rules

### Allow Azure Services
```hcl
sql_allow_azure_services = true
# Creates rule: 0.0.0.0 to 0.0.0.0
```

### Custom IP Ranges
```hcl
sql_firewall_rules = {
  "OfficeIP" = {
    start_ip = "203.0.113.0"
    end_ip   = "203.0.113.255"
  }
  "VPNRange" = {
    start_ip = "198.51.100.0"
    end_ip   = "198.51.100.255"
  }
}
```

## Private Endpoints

### SQL Server Private Endpoint
```hcl
enable_private_endpoint = true
private_endpoint_subnet_id = azurerm_subnet.private.id
private_dns_zone_ids = [azurerm_private_dns_zone.sql.id]
```

### PostgreSQL Private Access
```hcl
postgres_public_network_access_enabled = false
postgres_delegated_subnet_id = azurerm_subnet.postgres.id
postgres_private_dns_zone_id = azurerm_private_dns_zone.postgres.id
```

## Security Best Practices

1. **Use Managed Identity:** Prefer managed identity over connection strings
2. **Enable Azure AD Authentication:** Use Azure AD for SQL Server
3. **Private Endpoints:** Use private endpoints for production
4. **TLS 1.2:** Enforce minimum TLS 1.2
5. **Firewall Rules:** Restrict to specific IP ranges
6. **Encryption:** Enable Transparent Data Encryption (TDE)
7. **Backup:** Configure automated backups
8. **Monitoring:** Enable Advanced Threat Protection

## Backup Configuration

### SQL Server
```hcl
sql_backup_retention_days = 7  # 7-35 days
sql_geo_backup_enabled = true
```

### PostgreSQL
```hcl
postgres_backup_retention_days = 7  # 7-35 days
```

## High Availability

### SQL Server
- **Business Critical:** Zone-redundant, read replicas
- **Hyperscale:** Auto-scaling, fast backups

### PostgreSQL
```hcl
postgres_ha_mode = "ZoneRedundant"
postgres_standby_zone = 2
```

## Monitoring

### Metrics
- **CPU Percentage:** Server CPU usage
- **Data Space Used:** Database size
- **Log Space Used:** Transaction log size
- **DTU Percentage:** SQL Server DTU usage
- **Active Connections:** Number of connections

### Logs
- **Query Store:** SQL Server query performance
- **Slow Query Log:** PostgreSQL slow queries
- **Audit Logs:** Security and compliance

## Troubleshooting

### Connection Issues
- Verify firewall rules
- Check network connectivity
- Verify credentials
- Check TLS version

### Performance Issues
- Monitor DTU/CPU usage
- Check query performance
- Consider scaling up
- Optimize queries

### Backup Issues
- Verify backup retention settings
- Check storage quota
- Review backup schedules

## References

- [Azure SQL Database Documentation](https://docs.microsoft.com/azure/azure-sql/)
- [PostgreSQL Flexible Server Documentation](https://docs.microsoft.com/azure/postgresql/flexible-server/)
- [Terraform AzureRM Provider - SQL](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/mssql_server)
- [Terraform AzureRM Provider - PostgreSQL](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/postgresql_flexible_server)
