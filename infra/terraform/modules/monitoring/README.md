# Monitoring Module

This Terraform module creates Azure Log Analytics Workspace and Application Insights instances for monitoring microservices applications.

## Features

- **Log Analytics Workspace:** Centralized log collection and analysis
- **Application Insights:** Application performance monitoring (APM)
- **Deployment Modes:**
  - **Shared:** One Application Insights instance for all services
  - **Per-Service:** Separate Application Insights instance for each service
- **Configurable Retention:** Data retention policies
- **Cost Controls:** Daily quotas and data caps
- **Sampling:** Configurable telemetry sampling

## Usage

### Shared Application Insights Mode

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  location            = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  # Log Analytics Workspace
  log_analytics_workspace_name = "law-microservices-poc"
  log_analytics_retention_days = 30

  # Shared Application Insights
  application_insights_mode = "shared"
  shared_application_insights_name = "appi-microservices-poc"
  application_insights_retention_days = 90

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

### Per-Service Application Insights Mode

```hcl
module "monitoring" {
  source = "./modules/monitoring"

  location            = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  # Log Analytics Workspace
  log_analytics_workspace_name = "law-microservices-poc"
  log_analytics_retention_days = 30

  # Per-Service Application Insights
  application_insights_mode = "per-service"
  product_service_application_insights_name     = "appi-productservice-poc"
  order_service_application_insights_name      = "appi-orderservice-poc"
  notification_service_application_insights_name = "appi-notificationservice-poc"
  application_insights_retention_days = 90

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
| log_analytics_workspace_name | Log Analytics workspace name | `string` | `"law-microservices-poc"` |
| log_analytics_sku | Log Analytics SKU | `string` | `"PerGB2018"` |
| log_analytics_retention_days | Data retention in days | `number` | `30` |
| application_insights_mode | Deployment mode (shared or per-service) | `string` | `"shared"` |
| application_insights_type | Application type | `string` | `"web"` |
| application_insights_retention_days | Data retention in days | `number` | `90` |
| tags | Resource tags | `map(string)` | `{}` |

## Outputs

### Log Analytics Workspace

| Name | Description |
|------|-------------|
| log_analytics_workspace_id | Workspace ID |
| workspace_id | Workspace ID (alias) |
| log_analytics_workspace_name | Workspace name |
| log_analytics_workspace_workspace_id | Workspace GUID |

### Shared Mode Outputs

| Name | Description |
|------|-------------|
| shared_instrumentation_key | Instrumentation key (sensitive) |
| shared_connection_string | Connection string (sensitive) |
| instrumentation_key | Instrumentation key (alias, sensitive) |

### Per-Service Mode Outputs

| Name | Description |
|------|-------------|
| product_service_instrumentation_key | ProductService instrumentation key (sensitive) |
| order_service_instrumentation_key | OrderService instrumentation key (sensitive) |
| notification_service_instrumentation_key | NotificationService instrumentation key (sensitive) |
| all_instrumentation_keys | Map of all instrumentation keys (sensitive) |

## Log Analytics Workspace

### SKU Options

- **PerGB2018:** Pay per GB ingested (recommended)
- **CapacityReservation:** Reserved capacity
- **Free:** Limited free tier
- **PerNode:** Per-node pricing
- **Premium:** Premium features
- **Standard:** Standard features
- **Standalone:** Standalone pricing

### Retention Options

- **30, 31, 60, 90, 120, 180, 270, 365, 550, 730, 1095 days**

### Use Cases

- Centralized log collection
- Security and compliance auditing
- Performance monitoring
- Troubleshooting and diagnostics
- Cost analysis

## Application Insights

### Shared vs Per-Service Mode

**Shared Mode:**
- **Pros:** Lower cost, simpler management, unified view
- **Cons:** Less granular control, harder to isolate issues
- **Use Case:** Small to medium applications, cost-sensitive

**Per-Service Mode:**
- **Pros:** Better isolation, service-specific dashboards, easier troubleshooting
- **Cons:** Higher cost, more management overhead
- **Use Case:** Large applications, microservices, production environments

### Application Types

- **web:** Web applications (ASP.NET, ASP.NET Core)
- **other:** Other application types
- **java:** Java applications
- **MobileCenter:** Mobile Center
- **Node.JS:** Node.js applications
- **Phone:** Phone applications
- **UWP:** Universal Windows Platform

### Retention Options

- **30, 60, 90, 120, 180, 270, 365, 730 days**

## Using Instrumentation Keys in Applications

### .NET (ASP.NET Core)

**appsettings.json:**
```json
{
  "ApplicationInsights": {
    "InstrumentationKey": "your-instrumentation-key"
  }
}
```

**Program.cs:**
```csharp
builder.Services.AddApplicationInsightsTelemetry();
```

**Or using connection string (recommended):**
```json
{
  "ApplicationInsights": {
    "ConnectionString": "your-connection-string"
  }
}
```

### .NET (Classic)

**ApplicationInsights.config:**
```xml
<InstrumentationKey>your-instrumentation-key</InstrumentationKey>
```

**Or connection string:**
```xml
<ConnectionString>your-connection-string</ConnectionString>
```

### Storing in Key Vault

```hcl
# Shared mode
resource "azurerm_key_vault_secret" "app_insights_key" {
  name         = "ApplicationInsights-InstrumentationKey"
  value        = module.monitoring.shared_instrumentation_key
  key_vault_id = azurerm_key_vault.main.id
}

# Per-service mode
resource "azurerm_key_vault_secret" "product_service_key" {
  name         = "ProductService-ApplicationInsights-Key"
  value        = module.monitoring.product_service_instrumentation_key
  key_vault_id = azurerm_key_vault.main.id
}
```

### Using from Key Vault in Application

```csharp
// .NET example
var keyVaultClient = new SecretClient(
    new Uri("https://your-keyvault.vault.azure.net/"),
    new DefaultAzureCredential()
);

var instrumentationKey = await keyVaultClient.GetSecretAsync(
    "ApplicationInsights-InstrumentationKey"
);

builder.Services.AddApplicationInsightsTelemetry(
    instrumentationKey.Value.Value
);
```

## Cost Optimization

### Daily Quotas

```hcl
# Log Analytics daily quota (GB)
log_analytics_daily_quota_gb = 5

# Application Insights daily data cap (GB)
application_insights_daily_data_cap_gb = 1
```

### Sampling

```hcl
# Sample 50% of telemetry
application_insights_sampling_percentage = 50
```

**Sampling Benefits:**
- Reduces data ingestion
- Lowers costs
- Maintains statistical accuracy
- Configurable per telemetry type

### Retention

```hcl
# Shorter retention = lower cost
log_analytics_retention_days = 30
application_insights_retention_days = 90
```

## Monitoring Features

### Application Insights Features

- **Performance Monitoring:** Response times, throughput
- **Availability Monitoring:** Uptime monitoring, web tests
- **Dependency Tracking:** External service calls
- **Exception Tracking:** Unhandled exceptions
- **Custom Metrics:** Application-specific metrics
- **Live Metrics:** Real-time telemetry
- **Smart Detection:** Anomaly detection
- **Application Map:** Visual dependency map

### Log Analytics Features

- **Log Queries:** KQL (Kusto Query Language)
- **Workbooks:** Interactive dashboards
- **Alerts:** Metric and log alerts
- **Saved Searches:** Reusable queries
- **Data Export:** Export to storage
- **Solutions:** Pre-built solutions

## Integration with AKS

### Enable Container Insights

```hcl
# In AKS module
oms_agent {
  enabled                    = true
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id
}
```

### Enable Application Insights for AKS

```yaml
# Kubernetes deployment
apiVersion: apps/v1
kind: Deployment
metadata:
  name: product-service
spec:
  template:
    spec:
      containers:
      - name: product-service
        env:
        - name: APPLICATIONINSIGHTS_CONNECTION_STRING
          valueFrom:
            secretKeyRef:
              name: app-insights-secret
              key: connection-string
```

## Best Practices

1. **Use Connection Strings:** Prefer connection strings over instrumentation keys
2. **Store in Key Vault:** Never hardcode instrumentation keys
3. **Enable Sampling:** Use sampling for high-volume applications
4. **Set Daily Caps:** Configure daily data caps to control costs
5. **Monitor Costs:** Regularly review and optimize costs
6. **Use Per-Service Mode:** For production microservices
7. **Enable Smart Detection:** Use AI-powered anomaly detection
8. **Set Up Alerts:** Configure alerts for critical metrics
9. **Use Workbooks:** Create custom dashboards
10. **Regular Cleanup:** Review and remove unused resources

## Troubleshooting

### No Data in Application Insights

- Verify instrumentation key is correct
- Check application is sending telemetry
- Verify network connectivity
- Check daily data cap hasn't been reached
- Review sampling settings

### High Costs

- Review data ingestion volume
- Enable sampling
- Set daily data caps
- Reduce retention period
- Review and optimize queries
- Use shared mode if appropriate

### Missing Logs

- Check Log Analytics workspace connection
- Verify data sources are configured
- Check retention settings
- Review firewall rules
- Verify permissions

## References

- [Azure Monitor Documentation](https://docs.microsoft.com/azure/azure-monitor/)
- [Application Insights Documentation](https://docs.microsoft.com/azure/azure-monitor/app/app-insights-overview)
- [Log Analytics Documentation](https://docs.microsoft.com/azure/azure-monitor/logs/log-analytics-overview)
- [Terraform AzureRM Provider - Application Insights](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/application_insights)
- [Terraform AzureRM Provider - Log Analytics](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/log_analytics_workspace)
