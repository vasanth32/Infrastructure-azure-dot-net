# AKS Cluster Module

This Terraform module creates an Azure Kubernetes Service (AKS) cluster with system and user node pools, RBAC, Azure Monitor, and network configuration.

## Features

- **AKS Cluster** with managed identity
- **System Node Pool** (1 node by default) for system workloads
- **User Node Pool** (2-3 nodes by default) for application workloads
- **RBAC** enabled with optional Azure RBAC integration
- **Azure Monitor** (Container Insights) integration
- **Azure CNI** network plugin
- **Auto-scaling** support for user node pool
- **Upgrade settings** with surge protection

## Usage

```hcl
module "aks" {
  source = "./modules/aks"

  cluster_name         = "aks-microservices-poc"
  location             = "eastus"
  resource_group_name  = azurerm_resource_group.microservices.name
  dns_prefix           = "aks-microservices"

  # System Node Pool
  system_node_count    = 1
  system_node_vm_size  = "Standard_DS2_v2"

  # User Node Pool
  user_node_count      = 2
  user_node_min_count  = 2
  user_node_max_count  = 3
  user_node_vm_size    = "Standard_DS2_v2"
  enable_user_pool_autoscaling = true

  # Network
  subnet_id            = azurerm_subnet.aks.id

  # RBAC
  enable_azure_rbac    = true
  admin_group_object_ids = ["group-object-id-here"]

  # Azure Monitor
  enable_azure_monitor = true
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  # Tags
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
| cluster_name | Name of the AKS cluster | `string` | n/a |
| location | Azure region for the AKS cluster | `string` | n/a |
| resource_group_name | Name of the resource group | `string` | n/a |

### Optional

| Name | Description | Type | Default |
|------|-------------|------|---------|
| dns_prefix | DNS prefix for the AKS cluster | `string` | `"aks"` |
| kubernetes_version | Kubernetes version | `string` | `null` (latest) |
| subnet_id | Subnet ID for nodes | `string` | `null` |
| system_node_count | Number of system nodes | `number` | `1` |
| system_node_vm_size | VM size for system nodes | `string` | `"Standard_DS2_v2"` |
| user_node_count | Number of user nodes | `number` | `2` |
| user_node_min_count | Min nodes for autoscaling | `number` | `2` |
| user_node_max_count | Max nodes for autoscaling | `number` | `3` |
| user_node_vm_size | VM size for user nodes | `string` | `"Standard_DS2_v2"` |
| enable_user_pool_autoscaling | Enable autoscaling | `bool` | `true` |
| enable_azure_rbac | Enable Azure RBAC | `bool` | `true` |
| enable_azure_monitor | Enable Azure Monitor | `bool` | `true` |
| log_analytics_workspace_id | Log Analytics workspace ID | `string` | `null` |
| tags | Tags for resources | `map(string)` | `{}` |

## Outputs

| Name | Description |
|------|-------------|
| cluster_id | ID of the AKS cluster |
| cluster_name | Name of the AKS cluster |
| kube_config | Raw Kubernetes config (sensitive) |
| host | Kubernetes cluster server host (sensitive) |
| client_key | Client key for authentication (sensitive) |
| client_certificate | Client certificate for authentication (sensitive) |
| cluster_ca_certificate | Cluster CA certificate (sensitive) |
| system_node_pool_id | ID of the system node pool |
| user_node_pool_id | ID of the user node pool |
| kubernetes_version | Kubernetes version |

## Node Pools

### System Node Pool

- **Purpose:** Run system pods (kube-system, ingress controllers, etc.)
- **Default:** 1 node
- **Taints:** `CriticalAddonsOnly=true:NoSchedule`
- **Labels:** `kubernetes.azure.com/mode=system`

### User Node Pool

- **Purpose:** Run application workloads
- **Default:** 2-3 nodes (with autoscaling)
- **Taints:** None (by default)
- **Labels:** `kubernetes.azure.com/mode=user`

## Network Configuration

- **Network Plugin:** Azure CNI
- **Network Policy:** Optional (Calico)
- **Load Balancer:** Standard SKU
- **Service CIDR:** `10.0.0.0/16` (default)
- **DNS Service IP:** `10.0.0.10` (default)

## RBAC Configuration

- **RBAC:** Enabled by default
- **Azure RBAC:** Optional, enabled by default
- **Admin Groups:** Configure via `admin_group_object_ids`

## Azure Monitor

- **Container Insights:** Enabled by default
- **Log Analytics:** Requires workspace ID
- **Metrics:** Automatic collection
- **Logs:** Automatic collection

## Identity

- **Default:** System-assigned managed identity
- **Alternative:** Service principal (uncomment in main.tf)

## Security Best Practices

1. **Use Managed Identity:** Prefer system-assigned managed identity over service principals
2. **Enable Azure RBAC:** Use Azure AD for Kubernetes authorization
3. **Network Policies:** Enable network policies for pod-to-pod communication control
4. **API Server IP Ranges:** Restrict API server access to authorized IPs
5. **Node Pools:** Separate system and user workloads
6. **Upgrade Channel:** Use `stable` for production, `rapid` for testing

## Example: Complete Setup

```hcl
# Create Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = "law-microservices-poc"
  location            = azurerm_resource_group.microservices.location
  resource_group_name = azurerm_resource_group.microservices.name
  sku                 = "PerGB2018"
  retention_in_days   = 30
}

# Create Virtual Network
resource "azurerm_virtual_network" "main" {
  name                = "vnet-microservices"
  location            = azurerm_resource_group.microservices.location
  resource_group_name = azurerm_resource_group.microservices.name
  address_space       = ["10.0.0.0/16"]
}

# Create Subnet for AKS
resource "azurerm_subnet" "aks" {
  name                 = "snet-aks"
  resource_group_name  = azurerm_resource_group.microservices.name
  virtual_network_name = azurerm_virtual_network.main.name
  address_prefixes     = ["10.0.1.0/24"]
}

# Create AKS Cluster
module "aks" {
  source = "./modules/aks"

  cluster_name         = "aks-microservices-poc"
  location             = azurerm_resource_group.microservices.location
  resource_group_name  = azurerm_resource_group.microservices.name
  dns_prefix           = "aks-microservices"
  subnet_id            = azurerm_subnet.aks.id

  system_node_count    = 1
  user_node_count      = 2
  enable_user_pool_autoscaling = true
  user_node_min_count  = 2
  user_node_max_count  = 3

  enable_azure_monitor = true
  log_analytics_workspace_id = azurerm_log_analytics_workspace.main.id

  enable_azure_rbac    = true
  # admin_group_object_ids = [data.azuread_group.admins.object_id]

  tags = {
    Environment = "dev"
    Project     = "Microservices-POC"
  }
}
```

## Accessing the Cluster

After deployment, get the kubeconfig:

```bash
# Using Terraform output
terraform output -raw kube_config > ~/.kube/config-aks

# Or set KUBECONFIG
export KUBECONFIG=~/.kube/config-aks

# Verify access
kubectl get nodes
kubectl get pods --all-namespaces
```

## Troubleshooting

### Cluster Creation Fails

1. **Check Subnet:** Ensure subnet has enough IP addresses
2. **Check Permissions:** Verify service principal or managed identity has required permissions
3. **Check Quotas:** Verify subscription has sufficient VM quota

### Cannot Connect to Cluster

1. **Check RBAC:** Verify Azure AD group membership if using Azure RBAC
2. **Check API Server IPs:** Verify your IP is in authorized ranges
3. **Check kubeconfig:** Verify kubeconfig is correctly generated

### Node Pool Issues

1. **Check VM Size:** Ensure VM size is available in the region
2. **Check Subnet:** Ensure subnet has enough IPs for nodes
3. **Check Autoscaling:** Verify min/max counts are valid

## References

- [Azure Kubernetes Service Documentation](https://docs.microsoft.com/azure/aks/)
- [Terraform AzureRM Provider - AKS](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/kubernetes_cluster)
- [AKS Best Practices](https://docs.microsoft.com/azure/aks/best-practices)
