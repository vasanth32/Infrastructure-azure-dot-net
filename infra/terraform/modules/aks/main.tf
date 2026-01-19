# Azure Kubernetes Service Cluster
resource "azurerm_kubernetes_cluster" "main" {
  name                = var.cluster_name
  location            = var.location
  resource_group_name = var.resource_group_name
  dns_prefix          = var.dns_prefix
  kubernetes_version  = var.kubernetes_version

  # Identity Configuration
  identity {
    type = "SystemAssigned"
  }

  # Service Principal (alternative to managed identity)
  # Uncomment if you prefer service principal over managed identity
  # service_principal {
  #   client_id     = var.service_principal_client_id
  #   client_secret = var.service_principal_client_secret
  # }

  # Default Node Pool (System Pool)
  default_node_pool {
    name                = "systempool"
    node_count          = var.system_node_count
    vm_size             = var.system_node_vm_size
    type                = "VirtualMachineScaleSets"
    enable_auto_scaling = false
    os_disk_size_gb     = var.system_node_disk_size
    os_disk_type        = "Managed"
    vnet_subnet_id      = var.subnet_id

    # Node labels for system workloads
    # Note: kubernetes.azure.com prefix is reserved, use custom labels instead
    node_labels = {
      "node-pool-type" = "system"
    }

    # Note: node_taints are no longer supported on default node pool in AKS
    # Taints can only be applied to additional node pools

    # Upgrade settings
    upgrade_settings {
      max_surge = "33%"
    }
  }

  # Network Configuration
  network_profile {
    network_plugin    = "azure"
    network_policy    = var.enable_network_policy ? "azure" : null
    load_balancer_sku = "standard"
    service_cidr      = var.service_cidr
    dns_service_ip    = var.dns_service_ip
    docker_bridge_cidr = var.docker_bridge_cidr
  }

  # RBAC Configuration
  role_based_access_control_enabled = true

  # Azure AD Integration (optional but recommended)
  azure_active_directory_role_based_access_control {
    managed                = true
    azure_rbac_enabled     = var.enable_azure_rbac
    admin_group_object_ids = var.admin_group_object_ids
  }

  # Azure Monitor (Container Insights)
  # Note: oms_agent is configured via the oms_agent block
  # The enabled attribute is set via the log_analytics_workspace_id
  dynamic "oms_agent" {
    for_each = var.enable_azure_monitor && var.log_analytics_workspace_id != null ? [1] : []
    content {
      log_analytics_workspace_id = var.log_analytics_workspace_id
    }
  }

  # API Server Configuration
  api_server_authorized_ip_ranges = var.api_server_authorized_ip_ranges

  # Auto-scaling
  automatic_channel_upgrade = var.automatic_channel_upgrade

  # Note: HTTP Application Routing addon is deprecated
  # Use Ingress Controller (nginx, traefik) instead

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
    }
  )
}

# User Node Pool
resource "azurerm_kubernetes_cluster_node_pool" "userpool" {
  name                  = "userpool"
  kubernetes_cluster_id = azurerm_kubernetes_cluster.main.id
  node_count            = var.user_node_count
  vm_size               = var.user_node_vm_size
  os_type               = "Linux"
  os_disk_size_gb       = var.user_node_disk_size
  os_disk_type          = "Managed"
  vnet_subnet_id        = var.subnet_id

  # Auto-scaling
  enable_auto_scaling = var.enable_user_pool_autoscaling
  min_count           = var.enable_user_pool_autoscaling ? var.user_node_min_count : null
  max_count           = var.enable_user_pool_autoscaling ? var.user_node_max_count : null

  # Node labels
  # Note: kubernetes.azure.com prefix is reserved, use custom labels instead
  node_labels = merge(
    {
      "node-pool-type" = "user"
    },
    var.user_node_labels
  )

  # Node taints
  node_taints = var.user_node_taints

  # Upgrade settings
  upgrade_settings {
    max_surge = "33%"
  }

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      PoolType  = "User"
    }
  )
}
