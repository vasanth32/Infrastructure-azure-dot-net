terraform {
  required_version = ">= 1.0"
  
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "~> 3.0"
    }
  }
  
  # Uncomment and configure for remote state
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-state"
  #   storage_account_name = "tfstate"
  #   container_name       = "tfstate"
  #   key                  = "microservices.terraform.tfstate"
  # }
}

# Configure the Azure Provider
provider "azurerm" {
  features {
    resource_group {
      prevent_deletion_if_contains_resources = false
    }
  }
  
  # Uncomment if using service principal
  # subscription_id = var.subscription_id
  # client_id       = var.client_id
  # client_secret   = var.client_secret
  # tenant_id       = var.tenant_id
}

# Resource Group
resource "azurerm_resource_group" "microservices" {
  name     = var.resource_group_name != null ? var.resource_group_name : "rg-${var.environment}-microservices-poc"
  location = var.location

  tags = {
    Environment = var.environment
    Project     = "Microservices-POC"
    ManagedBy   = "Terraform"
  }
}

# Common Tags
locals {
  common_tags = {
    Environment = var.environment
    Project     = "Microservices-POC"
    ManagedBy   = "Terraform"
  }
}

# Monitoring Module (Log Analytics & Application Insights)
module "monitoring" {
  source = "./modules/monitoring"

  location            = var.location
  resource_group_name = azurerm_resource_group.microservices.name

  # Log Analytics Workspace
  log_analytics_workspace_name = "law-${var.environment}-microservices-poc"
  log_analytics_retention_days = 30

  # Application Insights - Shared mode for cost efficiency
  application_insights_mode = "shared"
  shared_application_insights_name = "appi-${var.environment}-microservices-poc"
  application_insights_retention_days = 90

  tags = local.common_tags
}

# Service Bus Module
module "servicebus" {
  source = "./modules/servicebus"

  namespace_name     = "sb-${var.environment}-microservices-poc"
  location           = var.location
  resource_group_name = azurerm_resource_group.microservices.name

  # Queue Configuration
  queue_name = "notification-queue"
  sku        = "Standard" # Basic, Standard, or Premium

  # Use default RootManageSharedAccessKey (auto-created by Azure)
  # Don't create a custom authorization rule to avoid conflicts
  create_namespace_authorization_rule = false

  tags = local.common_tags
}

# Databases Module
module "databases" {
  source = "./modules/databases"

  # Use eastus2 for SQL Server (provisioning disabled in eastus)
  # Other resources stay in the resource group's location (eastus)
  location            = "eastus2"  # SQL Server specific location
  resource_group_name = azurerm_resource_group.microservices.name

  # Database Type (sql or postgresql)
  database_type = var.database_type

  # SQL Server Configuration (if database_type = "sql")
  sql_server_name         = "sql-${var.environment}-microservices-poc"
  sql_admin_login         = var.sql_admin_login
  sql_admin_password      = var.sql_admin_password
  sql_public_network_access_enabled = true # Set to false for production

  # PostgreSQL Configuration (if database_type = "postgresql")
  # Only pass these if actually using PostgreSQL
  postgres_server_name         = "postgres-${var.environment}-microservices-poc"
  postgres_admin_login         = var.postgres_admin_login
  postgres_admin_password      = var.database_type == "postgresql" ? var.postgres_admin_password : ""
  postgres_public_network_access_enabled = true # Set to false for production

  # Database Names
  product_service_db_name = "ProductServiceDB"
  order_service_db_name    = "OrderServiceDB"

  tags = local.common_tags
}

# AKS Cluster Module
module "aks" {
  source = "./modules/aks"

  cluster_name        = var.aks_cluster_name
  location            = var.location
  resource_group_name = azurerm_resource_group.microservices.name

  # Network Configuration
  # Note: subnet_id is null, so AKS will create its own VNet
  # For production, create a VNet/subnet first and provide subnet_id
  subnet_id = var.aks_subnet_id

  # Node Pool Configuration
  system_node_count = 1
  system_node_vm_size = "Standard_D2s_v3" # Available in eastus

  user_node_min_count = 2
  user_node_max_count = 3
  user_node_vm_size   = "Standard_D2s_v3" # Available in eastus
  enable_user_pool_autoscaling = true

  # Azure Monitor Integration
  enable_azure_monitor        = true
  log_analytics_workspace_id = module.monitoring.log_analytics_workspace_id

  # RBAC
  enable_azure_rbac = true

  tags = local.common_tags
}
