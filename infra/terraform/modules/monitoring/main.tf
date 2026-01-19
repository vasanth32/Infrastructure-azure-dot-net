# Log Analytics Workspace
resource "azurerm_log_analytics_workspace" "main" {
  name                = var.log_analytics_workspace_name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku                 = var.log_analytics_sku
  retention_in_days   = var.log_analytics_retention_days

  # Daily quota in GB (optional, null = unlimited)
  daily_quota_gb = var.log_analytics_daily_quota_gb

  # Internet ingestion and query access
  internet_ingestion_enabled = var.log_analytics_internet_ingestion_enabled
  internet_query_enabled     = var.log_analytics_internet_query_enabled

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Purpose   = "Monitoring"
    }
  )
}

# Shared Application Insights (if shared mode)
resource "azurerm_application_insights" "shared" {
  count               = var.application_insights_mode == "shared" ? 1 : 0
  name                = var.shared_application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_insights_type
  workspace_id        = azurerm_log_analytics_workspace.main.id

  # Retention in days (30, 60, 90, 120, 180, 270, 365, or 730)
  retention_in_days = var.application_insights_retention_days

  # Daily data cap in GB
  daily_data_cap_in_gb = var.application_insights_daily_data_cap_gb

  # Sampling percentage (0-100)
  sampling_percentage = var.application_insights_sampling_percentage

  # Disable IP masking
  disable_ip_masking = var.application_insights_disable_ip_masking

  # Tags
  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Purpose   = "ApplicationInsights"
      Mode      = "Shared"
    }
  )
}

# ProductService Application Insights (if per-service mode)
resource "azurerm_application_insights" "product_service" {
  count               = var.application_insights_mode == "per-service" ? 1 : 0
  name                = var.product_service_application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_insights_type
  workspace_id        = azurerm_log_analytics_workspace.main.id

  retention_in_days        = var.application_insights_retention_days
  daily_data_cap_in_gb     = var.application_insights_daily_data_cap_gb
  sampling_percentage       = var.application_insights_sampling_percentage
  disable_ip_masking        = var.application_insights_disable_ip_masking

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Purpose   = "ApplicationInsights"
      Service   = "ProductService"
    }
  )
}

# OrderService Application Insights (if per-service mode)
resource "azurerm_application_insights" "order_service" {
  count               = var.application_insights_mode == "per-service" ? 1 : 0
  name                = var.order_service_application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_insights_type
  workspace_id        = azurerm_log_analytics_workspace.main.id

  retention_in_days        = var.application_insights_retention_days
  daily_data_cap_in_gb     = var.application_insights_daily_data_cap_gb
  sampling_percentage       = var.application_insights_sampling_percentage
  disable_ip_masking        = var.application_insights_disable_ip_masking

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Purpose   = "ApplicationInsights"
      Service   = "OrderService"
    }
  )
}

# NotificationService Application Insights (if per-service mode)
resource "azurerm_application_insights" "notification_service" {
  count               = var.application_insights_mode == "per-service" ? 1 : 0
  name                = var.notification_service_application_insights_name
  location            = var.location
  resource_group_name = var.resource_group_name
  application_type    = var.application_insights_type
  workspace_id        = azurerm_log_analytics_workspace.main.id

  retention_in_days        = var.application_insights_retention_days
  daily_data_cap_in_gb     = var.application_insights_daily_data_cap_gb
  sampling_percentage       = var.application_insights_sampling_percentage
  disable_ip_masking        = var.application_insights_disable_ip_masking

  tags = merge(
    var.tags,
    {
      ManagedBy = "Terraform"
      Purpose   = "ApplicationInsights"
      Service   = "NotificationService"
    }
  )
}
