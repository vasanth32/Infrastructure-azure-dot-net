# Service Bus Module

This Terraform module creates an Azure Service Bus namespace with a notification queue, authorization rules, and connection strings.

## Features

- **Service Bus Namespace** with configurable SKU (Basic, Standard, Premium)
- **Notification Queue** with comprehensive configuration options
- **Authorization Rules** for namespace and queue-level access
- **Connection Strings** for easy integration
- **Managed Identity** support
- **Security** features (TLS, local auth, public network access)

## Usage

```hcl
module "servicebus" {
  source = "./modules/servicebus"

  namespace_name      = "sb-microservices-poc"
  location            = "eastus"
  resource_group_name = azurerm_resource_group.microservices.name

  # Queue configuration
  queue_name = "notification-queue"

  # Namespace settings
  sku  = "Standard"
  local_auth_enabled = true

  # Authorization rule
  create_namespace_authorization_rule = true
  namespace_authorization_rule_name   = "RootManageSharedAccessKey"

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
| namespace_name | Name of the Service Bus namespace | `string` | n/a |
| location | Azure region | `string` | n/a |
| resource_group_name | Name of the resource group | `string` | n/a |

### Optional

| Name | Description | Type | Default |
|------|-------------|------|---------|
| sku | SKU (Basic, Standard, Premium) | `string` | `"Standard"` |
| queue_name | Name of the notification queue | `string` | `"notification-queue"` |
| max_delivery_count | Max delivery attempts | `number` | `10` |
| max_size_in_megabytes | Max queue size in MB | `number` | `1024` |
| dead_lettering_on_message_expiration | Enable dead lettering | `bool` | `true` |
| create_namespace_authorization_rule | Create namespace auth rule | `bool` | `true` |
| tags | Tags for resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| namespace_id | ID of the Service Bus namespace |
| namespace_name | Name of the Service Bus namespace |
| connection_string | Primary connection string (sensitive) |
| primary_connection_string | Primary connection string (sensitive) |
| secondary_connection_string | Secondary connection string (sensitive) |
| queue_name | Name of the notification queue |
| queue_id | ID of the notification queue |
| primary_key | Primary shared access key (sensitive) |
| secondary_key | Secondary shared access key (sensitive) |

## SKU Comparison

| Feature | Basic | Standard | Premium |
|---------|-------|----------|---------|
| Max message size | 256 KB | 256 KB | 1 MB |
| Max connections | 100 | 1,000 | 1,000 per messaging unit |
| Throughput | Limited | Higher | Highest |
| Geo-disaster recovery | No | No | Yes |
| Availability zones | No | No | Yes |
| Virtual network | No | No | Yes |
| Partitioning | No | Yes | No (not needed) |

## Queue Configuration

### Message TTL
- **Default:** Maximum TTL (effectively unlimited)
- **Format:** ISO 8601 duration (e.g., `PT1H` for 1 hour, `P1D` for 1 day)

### Lock Duration
- **Default:** 1 minute (`PT1M`)
- **Purpose:** Time a message is locked for processing
- **Format:** ISO 8601 duration

### Dead Lettering
- **Enabled by default** for message expiration
- Messages that exceed `max_delivery_count` are moved to dead-letter queue
- Dead-letter queue can be accessed separately

### Duplicate Detection
- **Disabled by default**
- When enabled, detects duplicate messages within time window
- **Time window:** Default 10 minutes (`PT10M`)

## Authorization Rules

### Namespace-Level Rule
- **Default name:** `RootManageSharedAccessKey`
- **Permissions:** Listen, Send, Manage (all enabled by default)
- **Use case:** Full access to namespace and all queues/topics

### Queue-Level Rule
- **Created:** Only if `create_queue_authorization_rule = true`
- **Permissions:** Configurable (Listen, Send, Manage)
- **Use case:** Restricted access to specific queue only

## Connection Strings

### Namespace Connection String
```
Endpoint=sb://{namespace}.servicebus.windows.net/;SharedAccessKeyName={rule_name};SharedAccessKey={key}
```

### Queue Connection String
```
Endpoint=sb://{namespace}.servicebus.windows.net/;SharedAccessKeyName={rule_name};SharedAccessKey={key};EntityPath={queue_name}
```

## Security Best Practices

1. **Use Managed Identity:** Prefer managed identity over connection strings
2. **Least Privilege:** Use queue-level rules with minimal permissions
3. **Rotate Keys:** Regularly rotate shared access keys
4. **TLS 1.2:** Use minimum TLS 1.2
5. **Private Endpoints:** Use private endpoints for Premium SKU
6. **Disable Public Access:** Disable public network access if not needed

## Example: Using Connection String in Application

### .NET (C#)
```csharp
using Azure.Messaging.ServiceBus;

var connectionString = "Endpoint=sb://...";
var queueName = "notification-queue";

var client = new ServiceBusClient(connectionString);
var sender = client.CreateSender(queueName);

var message = new ServiceBusMessage("Hello, Service Bus!");
await sender.SendMessageAsync(message);
```

### Python
```python
from azure.servicebus import ServiceBusClient, ServiceBusMessage

connection_string = "Endpoint=sb://..."
queue_name = "notification-queue"

with ServiceBusClient.from_connection_string(connection_string) as client:
    with client.get_queue_sender(queue_name) as sender:
        message = ServiceBusMessage("Hello, Service Bus!")
        sender.send_messages(message)
```

## Example: Using Managed Identity

```hcl
# Grant AKS managed identity Service Bus Data Owner role
resource "azurerm_role_assignment" "servicebus_data_owner" {
  principal_id         = azurerm_kubernetes_cluster.main.identity[0].principal_id
  role_definition_name = "Azure Service Bus Data Owner"
  scope                = azurerm_servicebus_namespace.main.id
}
```

### .NET (C#) with Managed Identity
```csharp
using Azure.Identity;
using Azure.Messaging.ServiceBus;

var fullyQualifiedNamespace = "sb-microservices-poc.servicebus.windows.net";
var queueName = "notification-queue";

var credential = new DefaultAzureCredential();
var client = new ServiceBusClient(fullyQualifiedNamespace, credential);
var sender = client.CreateSender(queueName);

var message = new ServiceBusMessage("Hello, Service Bus!");
await sender.SendMessageAsync(message);
```

## Monitoring

### Metrics
- **Active Messages:** Number of messages in queue
- **Dead-lettered Messages:** Number of dead-lettered messages
- **Incoming Messages:** Messages sent to queue
- **Outgoing Messages:** Messages received from queue
- **Size:** Current size of queue

### Logs
- **Operational Logs:** Namespace operations
- **Diagnostic Logs:** Enable in Azure Monitor

## Troubleshooting

### Connection String Issues
- Verify authorization rule exists
- Check permissions (Listen, Send, Manage)
- Verify namespace name is correct
- Check network access settings

### Message Not Received
- Check queue status (Active, Disabled, etc.)
- Verify lock duration is appropriate
- Check dead-letter queue
- Verify message TTL hasn't expired

### Performance Issues
- Upgrade to Premium SKU for higher throughput
- Enable partitioning (Standard SKU only)
- Increase capacity (Premium SKU)
- Use batched operations

## References

- [Azure Service Bus Documentation](https://docs.microsoft.com/azure/service-bus-messaging/)
- [Terraform AzureRM Provider - Service Bus](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/servicebus_namespace)
- [Service Bus Best Practices](https://docs.microsoft.com/azure/service-bus-messaging/service-bus-performance-improvements)
